require "octokit"

module Codestatus
  class PackageRepository
    class GitHubRepository
      def initialize(slug)
        # 'influitive/apartment'
        @repo = slug
      end

      def status
        status_of_default_branch
      end

      private

      # combined status on github
      # https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref
      def status_of_default_branch
        response = client.combined_status(@repo, default_branch)

        BuildStatus.new(sha: response.sha, status: response.state)
      end

      def default_branch
        repository['default_branch']
      end

      def repository
        @repository ||= client.repository(@repo)
      end

      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end

      def access_token
        ENV['CODESTATUS_GITHUB_TOKEN']
      end
    end
  end
end