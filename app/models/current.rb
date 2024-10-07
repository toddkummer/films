# frozen_string_literal: true

# # Current
#
# Model Current is a Rails pattern to provide easy access to the global, per-request attributes without passing them
# deeply around everywhere. The session is populated via authentication. Note that this is not an ActiveRecord.
class Current < ActiveSupport::CurrentAttributes
  attribute :session
  delegate :user, to: :session, allow_nil: true
end
