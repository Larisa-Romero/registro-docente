# frozen_string_literal: true

require "rails_helper"

feature "Deferring a trainee", type: :feature do
  include SummaryHelper

  before do
    given_i_am_authenticated
    given_a_trainee_exists
    and_i_am_on_the_trainee_edit_page
    and_i_click_on_defer
  end

  context "trainee withdrawal date" do
    scenario "choosing today" do
      when_i_choose_today
      and_i_continue
      then_i_am_redirected_to_deferral_confirmation_page
      and_the_defer_date_is_updated
    end

    scenario "choosing yesterday" do
      when_i_choose_yesterday
      and_i_continue
      then_i_am_redirected_to_deferral_confirmation_page
      and_the_defer_date_is_updated
    end

    context "choosing another day" do
      before do
        when_i_choose_another_day
      end

      scenario "and filling out a valid date" do
        and_i_enter_a_valid_date
        and_i_continue
        then_i_am_redirected_to_deferral_confirmation_page
        and_the_defer_date_is_updated
      end

      scenario "and not filling out the date displays the correct error" do
        and_i_continue
        then_i_see_the_error_message_for_blank_date
      end

      scenario "and filling out an invalid date displays the correct error" do
        defer_date_page.set_date_fields("defer_date", "32/01/2020")
        and_i_continue
        then_i_see_the_error_message_for_invalid_date
      end
    end
  end

  def when_i_choose_today
    when_i_choose("Today")
  end

  def when_i_choose_yesterday
    stub_dttp_placement_assignment_request(outcome_date: Time.zone.yesterday, status: 204)
    when_i_choose("Yesterday")
  end

  def and_i_enter_a_valid_date
    Faker::Date.in_date_period.tap do |defer_date|
      defer_date_page.set_date_fields(:defer_date, defer_date.strftime("%d/%m/%Y"))
    end
  end

  def and_i_am_on_the_trainee_edit_page
    edit_page.load(id: trainee.id)
  end

  def and_i_click_on_defer
    edit_page.defer.click
  end

  def when_i_choose(option)
    defer_date_page.choose(option)
  end

  def when_i_choose_another_day
    when_i_choose("On another day")
  end

  def and_i_continue
    deferral_page.continue.click
  end

  def then_i_see_the_error_message_for_invalid_date
    expect(page).to have_content(
      I18n.t("activemodel.errors.models.deferral_form.attributes.defer_date.invalid"),
    )
  end

  def then_i_see_the_error_message_for_blank_date
    expect(page).to have_content(
      I18n.t("activemodel.errors.models.deferral_form.attributes.defer_date.blank"),
    )
  end

  def then_i_am_redirected_to_deferral_confirmation_page
    expect(deferral_confirmation_page).to be_displayed(id: trainee.id)
  end

  def edit_page
    @edit_page ||= PageObjects::Trainees::Edit.new
  end

  def defer_date_page
    @edit_defer_date_page ||= PageObjects::Trainees::Deferral.new
  end

  def deferral_confirmation_page
    @deferral_confirmation_page ||= PageObjects::Trainees::ConfirmDeferral.new
  end

  def deferral_page
    @deferral_page ||= PageObjects::Trainees::Deferral.new
  end

  def and_the_defer_date_is_updated
    trainee.reload
    expect(page).to have_text(date_for_summary_view(trainee.defer_date))
  end
end
