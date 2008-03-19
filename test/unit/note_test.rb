require File.dirname(__FILE__) + '/../test_helper'

class NoteTest < ActiveSupport::TestCase
  def test_for_person
    assert_equal 4, Note.for_person(people(:mary)).size
    assert_equal 4, Note.count_for_person(people(:mary))
    assert_equal 2, Note.for_person(people(:mary), :limit => 2).size
  end
end
