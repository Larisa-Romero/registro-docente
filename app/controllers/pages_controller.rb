# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate

  def start
    session[:requested_path] = root_path
    if authenticated?
      @trainees = policy_scope(Trainee.all)
      @home_view = HomeView.new(@trainees)
      render(:home)
    else
      render(:start)
    end
  end

  def accessibility
    render(:accessibility)
  end

  def privacy_policy
    render(:privacy_policy)
  end

  def guidance
    render(:guidance)
  end
end
