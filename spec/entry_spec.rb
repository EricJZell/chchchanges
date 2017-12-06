require "spec_helper"

describe Chchchanges::Entry do
  describe '#initialize' do
    it 'creates a new instance of an Entry' do
      expect(subject).to be_an_instance_of(Chchchanges::Entry)
    end
  end

  describe '#call' do
    it 'creates a .changelog_entries directory if it does not exist' do
      allow(File).to receive(:write)
      setup_fake_input('1.0.0', '1', '001', 'test description', 'test1, test2')
      allow(Dir).to receive(:exists?).with('.changelog_entries').and_return(false)
      expect(Dir).to receive(:mkdir).with('.changelog_entries')
      subject.call
    end

    context 'user inputs valid data' do
      before(:example) { allow(Dir).to receive(:exists?).with('.changelog_entries').and_return(true) }
      it 'creates a new .json file with user entered data' do
        setup_fake_input('1.0.0', '1', '001', 'test description', 'test1, test2')
        info = {
          type: 'Added',
          ticket: '001',
          url: "",
          description: 'test description',
          version: '1.0.0',
          tags: ['test1', 'test2']
        }.to_json
        expect(File).to receive(:write).with(match(/\.changelog_entries\/\d{17}.+\.json/), info)
        subject.call
      end
    end

    context 'invalid user input' do
      before(:example) { allow(Dir).to receive(:exists?).with('.changelog_entries').and_return(true) }
      skip 'displays an error message to user on invalid version' do
        setup_fake_input('1...23', 'q')
        expect{ subject.call }.to output(/Invalid version number/).to_stdout
      end
    end

  end
end
