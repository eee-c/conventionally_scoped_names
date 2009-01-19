module ConventionallyScopedNames
  def scopes_for(klass)
    scopes_from_params.inject(klass){|proxy, scope| proxy.send(*scope)}
  end

  def scopes_from_params
    returning scopes = [] do
      (params[:scopes] || []).reject(&:blank?).each do |scope|
        case scope.class.to_s
        when "String"
          scopes << [scope]    if Post.scopes.include?(scope.to_sym)
        when "Hash", "HashWithIndifferentAccess"
          msg, arg = scope.first # {:foo => 'bar'}.first => [:foo, "bar"]
          scopes << [msg, arg] if Post.scopes.include?(msg.to_sym) && !arg.blank?
        end
      end
    end

    scopes.blank? ? [:all] : scopes
  end
end

class ActionController::Base
  include ConventionallyScopedNames
end
