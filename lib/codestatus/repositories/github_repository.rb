require "octokit"

module Codestatus
  module Repositories
    class GitHubRepository < Base
      # combined status on github
      # https://developer.github.com/v3/repos/statuses/#get-the-combined-status-for-a-specific-ref
      def status(ref = default_branch)
        response = client.combined_status(slug, ref)

        BuildStatus.new(sha: response.sha, status: response.state)
      end

      # https://github.com/meganemura/codestatus
      def html_url
        repository&.dig(:html_url)
      end

      private

      def default_branch
        repository&.dig(:default_branch)
      end

      def repository
        @repository ||= begin
                          # Sawyer::Resource -> Hash
                          client.repository(slug).to_hash
                        rescue Octokit::NotFound
                          nil
                        end
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
