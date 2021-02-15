----PUNDIT----

gem "pundit"
rails g pundit:install

creates application policy in app/policies/
all actions return a boolean

Appication Controller:

class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    include Pundit
  
    # Pundit: white-list approach.
    after_action :verify_authorized, except: :index, unless: :skip_pundit?
    after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  
    # Uncomment when you *really understand* Pundit!
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(root_path)
    end
  
    private
  
    def skip_pundit?
      devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
    end
  end
  

  rails g pundit:policy restaurant

  class RestaurantPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end
  
    def new?
      true
    end

  end
  

check if user is owner of a restaurant:

current_user == record.user (record and user come from pundit!)


redirect if not authorized:
application controller

rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

def user_not_authorized
  flash[:alert] = "You are not authorized to perform this action."
  redirect_to(request.referrer || root_path)
end


index action:

all restaurants have to be authorized
@restaurants = policy_scope(Restaurant)

p0licy:    scope.all is like Restaurant.all
specify with : scope.where(user: user)

special cases: order results

@restaurants = policy_scope(Restaurant).order(created_at: :desc)



conditional rendering with pundit

we call the policy on the restaurant instance

<% if policy(restaurant).edit? %>
    <td><%= link_to 'Edit', edit_restaurant_path(restaurant) %></td>
  <% end %>
  <% if policy(restaurant).destroy? %>
    <td><%= link_to 'Destroy', restaurant, method: :delete, data: { confirm: 'Are you sure?' } %></td>
  <% end %>

without having an instance

<% if policy(Restaurant).new? %>
    <%= link_to 'New Restaurant', new_restaurant_path %>
  <% end %>

