class BuildFilterModelsGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

    binding.pry

    class_option :model_type, type: :string, desc: "The Root directory for current application"
end
