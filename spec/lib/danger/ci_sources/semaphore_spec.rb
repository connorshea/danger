require "danger/ci_source/travis"

describe Danger::Semaphore do
  let(:valid_env) do
    {
      "SEMAPHORE" => "true",
      "PULL_REQUEST_NUMBER" => "800",
      "SEMAPHORE_REPO_SLUG" => "artsy/eigen"
    }
  end

  let(:invalid_env) do
    {
      "CIRCLE" => "true"
    }
  end

  let(:source) { described_class.new(valid_env) }

  describe ".validates_as_ci" do
    it "validates when the expected valid_env variables are set" do
      expect(described_class.validates_as_ci?(valid_env)).to be true
    end

    it "validates when `PULL_REQUEST_NUMBER` is missing" do
      valid_env["PULL_REQUEST_NUMBER"] = nil
      expect(described_class.validates_as_ci?(valid_env)).to be true
    end

    it "validates when `SEMAPHORE_REPO_SLUG` is missing" do
      valid_env["SEMAPHORE_REPO_SLUG"] = nil
      expect(described_class.validates_as_ci?(valid_env)).to be true
    end

    it "does not validated when some expected valid_env variables are missing" do
      expect(described_class.validates_as_ci?(invalid_env)).to be false
    end
  end

  describe ".validates_as_pr?" do
    it "validates when the expected valid_env variables are set" do
      expect(described_class.validates_as_pr?(valid_env)).to be true
    end

    it "does not validate if `PULL_REQUEST_NUMBER` is missing" do
      valid_env["PULL_REQUEST_NUMBER"] = nil
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end

    it "does not validate if `PULL_REQUEST_NUMBER` is empty" do
      valid_env["PULL_REQUEST_NUMBER"] = ""
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end

    it "does not validate if `SEMAPHORE_REPO_SLUG` is missing" do
      valid_env["SEMAPHORE_REPO_SLUG"] = nil
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end

    it "does not validate if `SEMAPHORE_REPO_SLUG` is empty" do
      valid_env["SEMAPHORE_REPO_SLUG"] = ""
      expect(described_class.validates_as_pr?(valid_env)).to be false
    end
  end

  it "gets the pull request ID" do
    env = { "PULL_REQUEST_NUMBER" => "2" }
    t = Danger::Semaphore.new(env)
    expect(t.pull_request_id).to eql("2")
  end

  it "gets the repo address" do
    env = { "SEMAPHORE_REPO_SLUG" => "orta/danger" }
    t = Danger::Semaphore.new(env)
    expect(t.repo_slug).to eql("orta/danger")
  end

  it "gets out a repo slug and pull request number" do
    env = {
      "SEMAPHORE" => "true",
      "PULL_REQUEST_NUMBER" => "800",
      "SEMAPHORE_REPO_SLUG" => "artsy/eigen"
    }
    t = Danger::Semaphore.new(env)
    expect(t.repo_slug).to eql("artsy/eigen")
    expect(t.pull_request_id).to eql("800")
  end
end
