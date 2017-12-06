require "spec_helper"

describe Chchchanges::Entry do
  describe '#initialize' do
    it 'creates a new instance of an Entry' do
      expect(subject).to be_an_instance_of(Chchchanges::Entry)
    end
  end

  describe '#call' do
    it 'creates a .changelog_entries directory if it does not exist' do
      setup_fake_input('quit')
      allow(Dir).to receive(:exists?).with('.changelog_entries').and_return(false)
      expect(Dir).to receive(:mkdir).with('.changelog_entries')
      Chchchanges::Entry.call
    end
  end
end
