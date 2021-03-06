require 'spec_helper'

describe 'rays clean' do
  include Rays::SpecHelper

  before(:each) do
    recreate_test_project
  end

  describe 'no parameters' do
    it 'should clean all modules from the project root' do
      name = 'test'
      module_instances = []
      module_types.each_key do |module_type|
        module_instances << generate_and_build(module_type, name).first
      end
      module_instances.each do |module_instance|
        is_built(module_instance).should be_true
      end
      in_directory(@project_root) do
        lambda { command.run(%w(clean)) }.should_not raise_error
      end
      module_instances.each do |module_instance|
        is_built(module_instance).should be_false
      end
    end

    it 'should clean all modules if from inside project but outside a module' do
      hierarchy_test_dir = File.join(@project_root, 'hierarchy_test')
      FileUtils.mkdir(hierarchy_test_dir) unless Dir.exist?(hierarchy_test_dir)
      name = 'test'
      module_instances = []
      module_types.each_key do |module_type|
        module_instances << generate_and_build(module_type, name).first
      end
      module_instances.each do |module_instance|
        is_built(module_instance).should be_true
      end
      in_directory(hierarchy_test_dir) do
        Rays::Core.instance.reload
        lambda { command.run(%w(clean)) }.should_not raise_error
      end
      module_instances.each do |module_instance|
        is_built(module_instance).should be_false
      end
    end

    it 'should clean specific module from the module\'s root' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(%w(clean)) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a specific module from inside the module' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(File.join(module_instance.path, 'src')) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(%w(clean)) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail if outside the project' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(%w(clean)) }.should raise_error
      end
    end
  end

  #
  # Portlet
  #
  describe 'portlet test' do
    it 'should clean a portlet from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a portlet from the portlet directory' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a portlet inside portlet directory' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(File.join(module_instance.path, 'src')) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:portlet, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end

  #
  # Service builder
  #
  describe 'servicebuilder test' do
    it 'should clean from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:servicebuilder, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean from the module directory' do
      name = 'test'
      module_instance = generate_and_build(:servicebuilder, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean inside module directory' do
      name = 'test'
      module_instance = generate_and_build(:servicebuilder, name).first
      in_directory(File.join(module_instance.path, "#{module_instance.name}-portlet-service")) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:servicebuilder, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end

  #
  # Ext plugin
  #
  describe 'ext test' do
    it 'should clean from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:ext, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean from the module directory' do
      name = 'test'
      module_instance = generate_and_build(:ext, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean inside the module directory' do
      name = 'test'
      module_instance = generate_and_build(:ext, name).first
      in_directory(File.join(module_instance.path, "#{name}-ext")) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:ext, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end


  #
  # Hook
  #
  describe 'hook test' do
    it 'should clean a hook from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:hook, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a hook from the hook directory' do
      name = 'test'
      module_instance = generate_and_build(:hook, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a hook inside hook directory' do
      name = 'test'
      module_instance = generate_and_build(:hook, name).first
      in_directory(File.join(module_instance.path, 'src')) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:hook, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end

  #
  # Theme
  #
  describe 'theme test' do
    it 'should clean a theme from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:theme, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a theme from the theme directory' do
      name = 'test'
      module_instance = generate_and_build(:theme, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a theme inside theme directory' do
      name = 'test'
      module_instance = generate_and_build(:theme, name).first
      in_directory(File.join(module_instance.path, 'src')) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:theme, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end

  #
  # Layout
  #
  describe 'layout test' do
    it 'should clean a layout from the project directory' do
      name = 'test'
      module_instance = generate_and_build(:layout, name).first
      in_directory(@project_root) do
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a layout from the layout directory' do
      name = 'test'
      module_instance = generate_and_build(:layout, name).first
      in_directory(module_instance.path) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should clean a layout inside layout directory' do
      name = 'test'
      module_instance = generate_and_build(:layout, name).first
      in_directory(File.join(module_instance.path, 'src')) do
        Rays::Core.instance.reload
        is_built(module_instance).should be_true
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should_not raise_error
      end
      is_built(module_instance).should be_false
    end

    it 'should fail from outside project directory' do
      name = 'test'
      module_instance = generate_and_build(:layout, name).first
      in_directory(Rays::Utils::FileUtils.parent(@project_root)) do
        is_built(module_instance).should be_true # must be before core reload!
        Rays::Core.instance.reload
        lambda { command.run(['clean', module_instance.type, module_instance.name]) }.should raise_error
      end
    end
  end

  # TODO: test for content_sync deploy

  #
  # Helping methods
  #

  def is_built(module_instance)
    unless module_instance.type.to_sym == :servicebuilder or module_instance.type.to_sym == :ext
      file = File.join(module_instance.path, "target/#{module_instance.name}-#{Rays::Project.instance.version}.war")
      File.exist?(file)
    else
      !Rays::Utils::FileUtils.find_down(module_instance.path, /.*\.war$/).empty?
    end
  end
end