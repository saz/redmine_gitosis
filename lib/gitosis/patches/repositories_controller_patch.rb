require_dependency 'repositories_controller'
module Gitosis
  module Patches
    module RepositoriesControllerPatch

      def show_with_git_instructions
        if @repository.is_a?(Repository::Git) and @repository.entries(@path, @rev).blank?
          render :action => 'git_instructions' 
        else
          show_without_git_instructions
        end
      end
      
      def edit_with_scm_settings
        params[:repository] ||= {}
        if params[:repository_scm] == 'Git'
            params[:repository][:url] = File.join(Setting.plugin_redmine_gitosis['basePath'], Gitosis.repository_name(@project) + ".git")
        end
        edit_without_scm_settings
      end

      def self.included(base)
        base.class_eval do
          unloadable
        end
        base.send(:alias_method_chain, :show, :git_instructions)
        base.send(:alias_method_chain, :edit, :scm_settings)
      end

    end
  end
end
RepositoriesController.send(:include, Gitosis::Patches::RepositoriesControllerPatch) unless RepositoriesController.include?(Gitosis::Patches::RepositoriesControllerPatch)
