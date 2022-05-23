module.exports = {
  branches: [
    '+([0-9])?(.{+([0-9]),x}).x',
    'main',
    { name: 'alpha', prerelease: true },
    { name: 'beta', prerelease: true },
    { name: 'rc', prerelease: true },
  ],
  plugins: [
    ['@semantic-release/commit-analyzer', {
      preset: 'conventionalcommits',
      releaseRules: [
        { breaking: true, release: 'major' },
        { revert: true, release: 'patch' },
        { type: 'ci', release: 'patch' },
        { type: 'deps', release: 'patch' },
        { type: 'docs', release: 'patch' },
        { type: 'feat', release: 'minor' },
        { type: 'fix', release: 'patch' },
        { type: 'perf', release: 'patch' },
        { type: 'refactor', release: 'patch' },
        { type: 'test', release: 'patch' },
        { scope: 'no-release', release: false }
      ]
    }],
    ['@semantic-release/exec', {
      'prepareCmd': 'bin/ci-release-version ${nextRelease.version}'
    }],
    ['@semantic-release/release-notes-generator', {
      preset: 'conventionalcommits',
      types: [
        { type: 'build', section: 'Build System', hidden: true },
        { type: 'chore', section: 'Miscellaneous Chores', hidden: true },
        { type: 'ci', section: 'Continuous Integration', hidden: true },
        { type: 'deps', section: 'Dependencies' },
        { type: 'docs', section: 'Documentation' },
        { type: 'feat', section: 'Features' },
        { type: 'fix', section: 'Bug Fixes' },
        { type: 'perf', section: 'Performance Improvements' },
        { type: 'refactor', section: 'Code Refactoring', hidden: true },
        { type: 'revert', section: 'Reverts' },
        { type: 'style', section: 'Styles', hidden: true },
        { type: 'test', section: 'Tests', hidden: true },
      ]
    }],
    ['@semantic-release/changelog', {
      changelogTitle: '# Jove Changelog'
    }],
    ['@semantic-release/git', {
      assets: ['CHANGELOG.md', 'VERSION']
    }],
    '@semantic-release/github'
  ]
}
