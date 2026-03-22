# Sync All Global Skills

## Context
GitHub repo에서 최신 catalog를 pull한 후, `scope: global`인 모든 스킬을 5개 에이전트 타겟에 동기화한다.
`sync-skills.sh`를 완전히 대체하는 원커맨드 솔루션.

## Steps

### 1. Pull Latest Catalog
```bash
cd <LIBRARY_SKILL_DIR>
git pull
```

### 2. Read and Filter
- `library.yaml`을 읽는다
- `library.skills`에서 `scope: global`인 엔트리만 필터링
- `scope` 필드가 없는 엔트리는 `project` (기본값)이므로 건너뛴다

### 3. Determine Sync Targets
`default_dirs.skills`에서 global 타겟 목록을 가져온다:

| Key | Path |
|-----|------|
| global | `~/.claude/skills/` |
| codex_global | `~/.codex/skills/` |
| gemini_global | `~/.gemini/skills/` |
| gsd_global | `~/.gsd/agent/skills/` |

### 4. Fetch and Deploy Each Skill
필터링된 각 스킬에 대해:

1. **Source에서 가져오기** — `use.md`의 "Fetch from Source" 단계와 동일
   - GitHub URL → `git clone --depth 1`로 가져와 parent directory 추출
   - Local path → 직접 참조

2. **4개 타겟에 복사**:
   ```bash
   # claude, codex, gemini 타겟
   cp -R <source_dir>/ ~/.claude/skills/<name>/
   cp -R <source_dir>/ ~/.codex/skills/<name>/
   cp -R <source_dir>/ ~/.gemini/skills/<name>/
   ```

3. **gsd 타겟은 SKILL.md만 복사** (gsd 포맷 호환):
   ```bash
   mkdir -p ~/.gsd/agent/skills/<name>/
   cp <source_dir>/SKILL.md ~/.gsd/agent/skills/<name>/SKILL.md
   ```

4. 타겟 디렉토리가 없으면 `mkdir -p`로 생성

### 5. Result Report
동기화 결과를 테이블로 출력:

```
## Sync Report

| Skill | claude | codex | gemini | gsd |
|-------|--------|-------|--------|-----|
| commit | OK | OK | OK | OK |
| feature-dev | OK | OK | OK | OK |
| ... | ... | ... | ... | ... |

Total: N skills synced to 4 targets
```

### 6. Error Handling
- 특정 타겟 디렉토리 생성 실패 → 해당 타겟만 SKIP 표시하고 계속 진행
- GitHub clone 실패 → 해당 스킬 FAILED 표시하고 계속 진행
- 모든 에러는 리포트 하단에 요약
