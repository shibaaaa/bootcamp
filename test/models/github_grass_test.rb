# frozen_string_literal: true

require "test_helper"

class GithubGrassTest < ActiveSupport::TestCase
  test "#fetch" do
    skip
    assert_match %r{svg}, GithubGrass.new("komagata").fetch
    assert_no_match %r{svg}, GithubGrass.new("komagata1234").fetch
  end
end
