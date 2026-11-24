# 巨数的表达边界 Lean 工程

这是小组项目的 Lean 工程，包含 mathlib、共用定义、2 号的 DFA 构造与正确性证明。DFA 使用 N + 2 个状态，接受且仅接受长度为 N 的一元串。下界、最小性拼接与其他成员模块仍待开发。

## 本机开始使用

1. 如果安装前已打开 VS Code，请先保存工作并完全退出 VS Code，再重新打开，让新安装的工具和用户环境变量生效。
2. 双击 `Open-VSCode.cmd`，或在 VS Code 中选择“文件 → 打开文件夹”，打开整个 `HugeNumbers` 文件夹。
3. 打开 `HugeNumbers/DFAConstruction.lean` 开始工作。不要只打开单个文件而不打开工程目录。
4. 双击 `Verify.cmd`，或在工程根目录的 PowerShell 终端运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Verify.ps1
```

检查应显示 `PASS: project build and smoke check.`。若提示找不到 `lake`，可先运行 `. .\scripts\Enter-Environment.ps1`，或重新打开终端。

## 固定版本

- Lean：`leanprover/lean4:v4.36.0`，由 `lean-toolchain` 固定。
- mathlib：`v4.36.0`，由 `lakefile.toml` 固定。
- 全部传递依赖：由 `lake-manifest.json` 固定。
- Lake 随 Lean 工具链一起安装，无需单独安装。

不要单独修改 Lean 或 mathlib 的版本。升级时需全组协调，并重新获取对应缓存、构建和复核。

## 组员首次配置

先安装 Git、VS Code、官方 `leanprover.lean4` 扩展，并通过 Lean 的 Setup Guide 安装 elan。

- [Lean 官方安装说明](https://lean-lang.org/install/manual/)
- [mathlib 工程说明](https://leanprover-community.github.io/install/project)

共享仓库为 [kudduskali9-alt/HugeNumbers](https://github.com/kudduskali9-alt/HugeNumbers)，可见性为私有。组员需先接受仓库所有者的协作者邀请，再克隆：

```powershell
git clone https://github.com/kudduskali9-alt/HugeNumbers.git
cd HugeNumbers
```

进入工程根目录后执行：

```powershell
lake exe cache get Mathlib.Computability.DFA
lake build
lake env lean Checks/Smoke.lean
```

第一条只下载当前 DFA 相关模块及其传递依赖的预编译缓存，首次运行需要联网，elan 会按 `lean-toolchain` 安装正确的 Lean。后续引入更多 mathlib 模块时，可指定对应模块获取缓存；需要完整 mathlib 缓存时运行 `lake exe cache get`，下载量和磁盘占用会更大。

Windows 也可运行下面的一键命令，包含当前工程所需缓存下载：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Verify.ps1 -GetCache
```

## 文件布局

| 文件 | 用途 |
| --- | --- |
| `HugeNumbers.lean` | 总入口；新增已完成模块时在此导入 |
| `HugeNumbers/Basic.lean` | 一元字母表、一元串、目标语言与基础引理 |
| `HugeNumbers/DFAConstruction.lean` | DFA 构造、读串不变量、正确性和状态数证明 |
| `Checks/Smoke.lean` | 真实 DFA 边界样例、超长串检查和核心定理公理检查 |
| `docs/DFAHandoff.md` | 交给 3 号的定理接口、证明思路和复跑说明 |
| `docs/Conventions.md` | 统一约定及待全组确认的事项 |
| `scripts/Verify.ps1` | 构建与环境检查 |
| `lean-toolchain`、`lakefile.toml`、`lake-manifest.json` | 工具链、直接依赖和锁定依赖 |

## 后续协作

主分支为 `main`，远程名为 `origin`。仓库所有者可在 Settings → Collaborators 中添加组员。私有仓库的链接本身不会授予访问权限。

组员开始工作前拉取最新主分支，再创建自己的分支，例如 3 号：

```powershell
git switch main
git pull --ff-only origin main
git switch -c person3/dfa-lower
```

完成后仅提交自己的改动文件，推送该分支，并在 GitHub 发起合并到 `main` 的 Pull Request。例如：

```powershell
git add HugeNumbers/DFALower.lean
git commit -m "Prove DFA state lower bound"
git push -u origin person3/dfa-lower
```

另附的源码压缩包不含 `.git` 和 `.lake`。使用压缩包的组员需按首次配置步骤获取依赖；若需要把解压后的目录作为新仓库，可执行 `git init -b main`。

每人建立自己的分支。合并前提供改动文件、复跑命令、预期结果和复核人。提交源码、文档和三个版本配置文件，不提交 `.lake`；其中包含可重新下载的依赖与构建结果。

其他模块建议沿用任务文档中的名称：`Tower.lean`、`DFALower.lean`、`DFAMinimum.lean`、`BusyBeaver.lean`。文件完成后由 2 号加入总入口，并执行 `lake build`。最终请 1 号在独立克隆中复跑。

## 2 号 DFA 模块的交接

构造名为 `HugeNumbers.exactLengthDFA`。核心接口为 `exactLengthDFA_eval_val`、`exactLengthDFA_mem_accepts`、`exactLengthDFA_accepts` 和 `dfaState_card`。详细签名见 `docs/DFAHandoff.md`。

3 号可导入 `HugeNumbers.DFAConstruction`，证明任意识别该语言的有限完整 DFA 都至少有 N + 2 个状态，再与本构造拼接最小性定理。当前只完成构造和上界，不把它当作最小性结论。
