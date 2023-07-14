# frozen_string_literal: true

require 'application_system_test_case'

class Practice::SortTest < ApplicationSystemTestCase
  test 'mentor user can access practices sort page' do
    visit_with_auth course_sort_index_path(courses(:course1).id), 'mentormentaro'
    within('.page-body__column.is-main') do
      assert_selector '.js-grab'
    end
  end

  test 'non-mentor user cannot access practices sort page' do
    visit_with_auth course_sort_index_path(courses(:course1).id), 'kimura'
    assert_text 'メンターとしてログインしてください'
  end
end
