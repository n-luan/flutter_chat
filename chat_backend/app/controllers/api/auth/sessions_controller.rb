class Api::Auth::SessionsController < DeviseTokenAuth::SessionsController
  def create
    # Check
    field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

    @resource = nil
    if field
      q_value = get_case_insensitive_field_from_resource_params(field)

      @resource = find_resource(field, q_value)
    end

    if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      valid_password = @resource.valid_password?(resource_params[:password])
      if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
        return render_create_error_bad_credentials
      end
      @client_id, @token = @resource.create_token
      @resource.save

      DeviceToken.where(token: params[:device_token]).destroy_all

      @resource.device_tokens.create token: params[:device_token]
      sign_in(:user, @resource, store: false, bypass: false)

      yield @resource if block_given?

      render_create_success
    elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
      if @resource.respond_to?(:locked_at) && @resource.locked_at
        render_create_error_account_locked
      else
        render_create_error_not_confirmed
      end
    else
      render_create_error_bad_credentials
    end
  end

  def destroy
    # remove auth instance variables so that after_action does not run
    user = remove_instance_variable(:@resource) if @resource
    client_id = remove_instance_variable(:@client_id) if @client_id
    remove_instance_variable(:@token) if @token

    if user && client_id && user.tokens[client_id]
      user.tokens.delete(client_id)
      user.save!

      DeviceToken.where(token: request.headers["HTTP_DEVICE_TOKEN"]).destroy_all

      yield user if block_given?

      render_destroy_success
    else
      render_destroy_error
    end
  end
end
