module.exports = {
  branches: ['main'],
  plugins: [
    ['@semantic-release/commit-analyzer', {
      releaseRules: [
        { breaking: true, release: 'major' },
        { revert: true, release: 'patch' },
        { type: 'feat', release: 'minor' },
        { type: 'fix', release: 'patch' },
        { type: 'perf', release: 'patch' },
        { type: 'refactor', release: 'patch' },
        { type: 'test', release: 'patch' },
        { type: 'ci', release: 'patch' },
        { type: 'docs', release: false },
      ]
    }],
    '@semantic-release/release-notes-generator',
    ['@semantic-release/changelog', {
      changelogTitle: '# Jove Changelog'
    }],
    ['@semantic-release/exec', {
      'publishCmd': 'bin/ci-release-version ${nextRelease.version}'
    }],
    ['@semantic-release/git', {
      assets: ['CHANGELOG.md', 'VERSION']
    }],
    '@semantic-release/github'
  ]
}
