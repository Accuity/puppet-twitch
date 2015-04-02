require 'bundler/gem_tasks'

module Bundler
  class GemHelper

    def install_latest_task
      desc "Build #{name}-#{version}.gem and create #{name}-latest.gem symlink"
      task :latest => :build do
        gem_file  = "#{name}-#{version}.gem"
        link_path = File.join(base, 'pkg', "#{name}-latest.gem")

        FileUtils.symlink(gem_file, link_path, {:force => true})

        Bundler.ui.confirm "#{File.basename(link_path)} linked to #{gem_file}"
      end
    end

  end
end
Bundler::GemHelper.instance.install_latest_task
