# frozen_string_literal: true

module RecordActions
  class View < GovukComponent::Base
    include ApplicationHelper
    include SummaryHelper

    attr_reader :trainee

    def initialize(trainee, has_missing_fields: false)
      @trainee = trainee
      @has_missing_fields = has_missing_fields
    end

    def display_actions?
      trainee.submitted_for_trn? || trainee.trn_received? || trainee.deferred?
    end

    def can_recommend_for_award?
      trainee.trn_received? && !has_missing_fields && !course_starting_in_the_future?
    end

    def action_links
      links = []

      if withdraw_allowed?
        links.prepend(withdraw_link)
      end

      if trainee.deferred?
        links.prepend(reinstate_link)
      else
        links.prepend(defer_link)
      end

      if delete_allowed?
        links.prepend(delete_link)
      end

      links.join(" or ").html_safe
    end

    def inset_text
      if has_missing_fields
        t("views.trainees.edit.status_summary.missing_fields")
      elsif course_starting_in_the_future?
        t("views.trainees.edit.status_summary.itt_not_started", itt_start_date: date_for_summary_view(trainee.course_start_date))
      else
        t("views.trainees.edit.status_summary.#{trainee.state}")
      end
    end

    def button_text
      if trainee.early_years_route?
        t("views.trainees.edit.recommend_for_eyts")
      else
        t("views.trainees.edit.recommend_for_award")
      end
    end

  private

    attr_reader :has_missing_fields

    def delete_link
      govuk_link_to(t("views.trainees.edit.delete"), trainee_start_date_verification_path(trainee, context: :delete), class: "delete")
    end

    def defer_link
      govuk_link_to(t("views.trainees.edit.defer"), trainee_deferral_path(trainee), class: "defer")
    end

    def withdraw_link
      govuk_link_to(t("views.trainees.edit.withdraw"), relevant_redirect_path, class: "withdraw")
    end

    def reinstate_link
      govuk_link_to(t("views.trainees.edit.reinstate"), trainee_reinstatement_path(trainee), class: "reinstate")
    end

    def delete_allowed?
      course_starting_in_the_future? || course_started_but_no_specified_start_date?
    end

    def withdraw_allowed?
      !course_starting_in_the_future? && !trainee.itt_not_yet_started?
    end

    def course_starting_in_the_future?
      trainee.starts_course_in_the_future?
    end

    def course_started_but_no_specified_start_date?
      !course_starting_in_the_future? && trainee.commencement_date.blank?
    end

    def relevant_redirect_path
      if trainee.commencement_date.present?
        trainee_withdrawal_path(trainee)
      else
        trainee_start_date_verification_path(trainee, context: :withdraw)
      end
    end
  end
end
