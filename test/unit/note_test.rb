require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def test_for_person
    assert_equal 4, Note.for_person(people(:mary)).size
    assert_equal 4, Note.count_for_person(people(:mary))
    assert_equal 2, Note.for_person(people(:mary), :limit => 2).size
  end
end

# == Schema Information
#
# Table name: notes
#
#  id            :integer(4)      not null, primary key
#  text          :text
#  notable_id    :integer(4)
#  notable_type  :string(255)
#  created_by_id :integer(4)
#  updated_by_id :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

