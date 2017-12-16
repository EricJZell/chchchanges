require "spec_helper"

describe Chchchanges::Entry do
  describe '#initialize' do
    it 'creates a new instance of an Entry' do
      expect(subject).to be_an_instance_of(Chchchanges::Entry)
    end
    it 'sets the default entry directory to .changelog_entries' do
      expect(subject.entry_file_dir).to eq('.changelog_entries')
    end
    it 'allows for setting a different entry directory' do
      entry = Chchchanges::Entry.new('test_directory')
      expect(entry.entry_file_dir). to eq('test_directory')
    end
  end

  describe '#call' do
    let(:subject) { Chchchanges::Entry.new('spec/.changelog_entries')}
    it 'creates a changelog_entries directory if it does not exist' do
      allow(File).to receive(:write)
      setup_fake_input('1.0.0', '1', '001', 'test description', 'test1, test2')
      allow(Dir).to receive(:exists?).with('spec/.changelog_entries').and_return(false)
      expect(Dir).to receive(:mkdir).with('spec/.changelog_entries')
      subject.call
    end

    context 'user inputs valid data' do
      let(:info) do
        {
          type: 'Added',
          ticket: '001',
          url: "",
          description: 'test description',
          version: '1.0.0',
          tags: ['test1', 'test2']
        }
      end

      it 'creates a new .json file with user entered data' do
        setup_fake_input('1.0.0', '1', '001', 'test description', 'test1, test2')
        expect(File).to receive(:write).with(match(/spec\/\.changelog_entries\/\d{17}.+\.json/), info.to_json)
        subject.call
      end
      it 'allows blank ticket number' do
        info[:ticket] = ''
        setup_fake_input('1.0.0', '1', '', 'test description', 'test1, test2')
        expect(File).to receive(:write).with(match(/spec\/\.changelog_entries\/\d{17}.+\.json/), info.to_json)
        subject.call
      end
      it 'allows blank tags' do
        info[:tags] = []
        setup_fake_input('1.0.0', '1', '001', 'test description', '')
        expect(File).to receive(:write).with(match(/spec\/\.changelog_entries\/\d{17}.+\.json/), info.to_json)
        subject.call
      end
      it 'saves files in name format strftime("%Y%m%d%H%M%S%L")}_ticket{ticket}.json' do
        time = Time.new(2018, 1, 1, 0, 0, 0, 0)
        allow(Time).to receive(:now).and_return(time)
        setup_fake_input('1.0.0', '1', '001', 'test description', 'test1, test2')
        expect(File).to receive(:write).with(
          'spec/.changelog_entries/20180101000000000_ticket001.json', info.to_json
        )
        subject.call
      end
    end

    context 'invalid user input' do
      before(:example) do
        allow(File).to receive(:write)
      end
      it 'displays an error message to user on invalid version' do
        setup_fake_input('1...23', '1.2.0', '1', '001', 'test description', 'test1, test2')
        expect{ subject.call }.to output(/Invalid version number/).to_stdout
      end
      it 'displays an error message to user on invalid change type' do
        setup_fake_input('1.2.0', '8', '1', '001', 'test description', 'test1, test2')
        expect{ subject.call }.to output(/Invalid change type selection/).to_stdout
      end
      it 'displays an error message for too short of a description' do
        setup_fake_input('1.2.0', '8', '1', '001', 'desc', 'good description', 'test1, test2')
        expect{ subject.call }.to output(/Invalid Description/).to_stdout
      end
    end

  end
end
