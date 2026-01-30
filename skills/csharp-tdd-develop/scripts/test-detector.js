#!/usr/bin/env node
/**
 * Test Detector for C# TDD Develop Skill
 *
 * .csproj 파일에서 NuGet 패키지 참조를 분석하여 테스트 환경을 감지합니다.
 *
 * Usage:
 *    node test-detector.js --detect              # 테스트 환경 감지
 *    node test-detector.js --detect <path>       # 특정 경로에서 감지
 *
 * Examples:
 *    node test-detector.js --detect
 *    node test-detector.js --detect ./tests/UnitTests
 */

const fs = require('fs');
const path = require('path');

/**
 * .csproj 파일에서 PackageReference 추출
 * @param {string} csprojContent - .csproj 파일 내용
 * @returns {string[]} 패키지 이름 목록
 */
function extractPackageReferences(csprojContent) {
  const packageRegex = /<PackageReference\s+Include="([^"]+)"/g;
  const packages = [];
  let match;

  while ((match = packageRegex.exec(csprojContent)) !== null) {
    packages.push(match[1].toLowerCase());
  }

  return packages;
}

/**
 * 디렉토리에서 .csproj 파일 찾기
 * @param {string} dir - 검색 디렉토리
 * @param {number} depth - 최대 검색 깊이
 * @returns {string[]} .csproj 파일 경로 목록
 */
function findCsprojFiles(dir, depth = 3) {
  const results = [];

  function search(currentDir, currentDepth) {
    if (currentDepth > depth) return;

    let entries;
    try {
      entries = fs.readdirSync(currentDir, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      const fullPath = path.join(currentDir, entry.name);

      if (entry.isFile() && entry.name.endsWith('.csproj')) {
        results.push(fullPath);
      } else if (entry.isDirectory() && !entry.name.startsWith('.') && entry.name !== 'node_modules' && entry.name !== 'bin' && entry.name !== 'obj') {
        search(fullPath, currentDepth + 1);
      }
    }
  }

  search(dir, 0);
  return results;
}

/**
 * 테스트 환경 감지
 * @param {string} searchDir - 검색 시작 디렉토리
 * @returns {Object} 테스트 환경 정보
 */
function detectTestEnvironment(searchDir) {
  const env = {
    runner: null,
    fluentAssertions: false,
    moq: false,
    nsubstitute: false,
    coverlet: false,
    testCommand: 'dotnet test',
    testProjects: [],
    issues: [],
  };

  const csprojFiles = findCsprojFiles(searchDir);

  if (csprojFiles.length === 0) {
    env.issues.push('No .csproj files found');
    return env;
  }

  for (const csprojPath of csprojFiles) {
    let content;
    try {
      content = fs.readFileSync(csprojPath, 'utf-8');
    } catch (e) {
      env.issues.push(`Failed to read ${csprojPath}: ${e.message}`);
      continue;
    }

    const packages = extractPackageReferences(content);
    const isTestProject =
      packages.some(p => p.includes('xunit') || p.includes('nunit') || p.includes('mstest')) ||
      packages.includes('microsoft.net.test.sdk');

    if (!isTestProject) continue;

    env.testProjects.push(path.relative(searchDir, csprojPath));

    // 테스트 러너 감지
    if (packages.some(p => p.startsWith('xunit'))) {
      env.runner = env.runner || 'xUnit';
    } else if (packages.some(p => p.startsWith('nunit'))) {
      env.runner = env.runner || 'NUnit';
    } else if (packages.some(p => p.startsWith('mstest') || p === 'microsoft.visualstudio.testplatform.testframework')) {
      env.runner = env.runner || 'MSTest';
    }

    // 추가 라이브러리 감지
    if (packages.includes('fluentassertions')) {
      env.fluentAssertions = true;
    }
    if (packages.includes('moq')) {
      env.moq = true;
    }
    if (packages.includes('nsubstitute')) {
      env.nsubstitute = true;
    }
    if (packages.includes('coverlet.collector')) {
      env.coverlet = true;
    }
  }

  if (!env.runner) {
    env.issues.push('No test runner found (xUnit, NUnit, or MSTest required)');
  }

  return env;
}

/**
 * 환경 정보 출력
 */
function printEnvironment(env) {
  console.log('## Test Environment');
  console.log('');
  console.log(`Runner: ${env.runner || 'NOT FOUND'} ${env.runner ? '✓' : '✗'}`);
  console.log(`FluentAssertions: ${env.fluentAssertions ? 'YES ✓' : 'NO'}`);
  console.log(`Moq: ${env.moq ? 'YES ✓' : 'NO'}`);
  console.log(`NSubstitute: ${env.nsubstitute ? 'YES ✓' : 'NO'}`);
  console.log(`Coverlet: ${env.coverlet ? 'YES ✓' : 'NO'}`);
  console.log('');

  if (env.testProjects.length > 0) {
    console.log('Test Projects:');
    env.testProjects.forEach(p => console.log(`  - ${p}`));
    console.log('');
  }

  console.log(`Test Command: ${env.testCommand}`);

  if (env.issues.length > 0) {
    console.log('');
    console.log('## Issues');
    env.issues.forEach(issue => console.log(`  - ${issue}`));
  }
}

/**
 * 미설치 패키지 설치 명령어 생성
 */
function getMissingDependencies(env) {
  const missing = [];

  if (!env.runner) {
    missing.push('dotnet add package xunit');
    missing.push('dotnet add package xunit.runner.visualstudio');
    missing.push('dotnet add package Microsoft.NET.Test.Sdk');
  }

  return missing;
}

function main() {
  const args = process.argv.slice(2);

  if (!args.includes('--detect')) {
    console.log('Usage: node test-detector.js --detect [path]');
    console.log('');
    console.log('Options:');
    console.log('  --detect [path]  Detect test environment from .csproj files');
    console.log('');
    console.log('Examples:');
    console.log('  node test-detector.js --detect');
    console.log('  node test-detector.js --detect ./tests');
    process.exit(1);
  }

  const detectIndex = args.indexOf('--detect');
  const searchDir = args[detectIndex + 1] || process.cwd();

  const env = detectTestEnvironment(searchDir);
  printEnvironment(env);

  const missingDeps = getMissingDependencies(env);
  if (missingDeps.length > 0) {
    console.log('');
    console.log('## Missing Dependencies');
    missingDeps.forEach(cmd => console.log(`  ${cmd}`));
  }

  process.exit(env.issues.length > 0 ? 1 : 0);
}

main();
