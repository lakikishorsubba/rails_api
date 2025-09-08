
# it is a fake racksession manager to trick and prevent session errors.
# this is because Devise uses session but --API do not have any sessions.
# module is created to call/reuse in other controller.
module RackSessionsFix
  extend ActiveSupport::Concern
  class FakeRackSession < Hash
    def enabled?
      false
    end
    def destroy; end
  end
  included do
    before_action :set_fake_session
    private
    def set_fake_session
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end