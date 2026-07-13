---
trigger: always_on
---

\## Coding Rules



1\. SPEC FILE: Read PLAN.md (or the designated spec file) before starting.

&nbsp;  This is your primary instruction set. The spec overrides conversational

&nbsp;  instructions where they conflict.



2\. COMMIT CADENCE: After completing each logical unit of work (one task,

&nbsp;  one function, one test suite), create a git commit with a descriptive

&nbsp;  message. Never batch multiple tasks into a single commit.



3\. CHECKPOINT UPDATES: After each commit, update PLAN.md — check off the

&nbsp;  completed item and add any decisions or notes to the Decisions Log

&nbsp;  section. This makes the spec file a live recovery checkpoint.



4\. CONTEXT DISCIPLINE:

&nbsp;  - Do not read files you don't need for the current task

&nbsp;  - Do not re-read large files that haven't changed since last read

&nbsp;  - If a file exceeds 300 lines and you only need a section, read the

&nbsp;    specific line range rather than the full file

&nbsp;  - Do not use yourself to append to large log files; suggest a shell

&nbsp;    command or script instead



5\. SCOPE DISCIPLINE: Only modify files and code paths specified in the

&nbsp;  current task. Do not refactor, rename, or "improve" code outside scope

&nbsp;  even if you notice opportunities. Note them in the Decisions Log instead.



6\. FAILURE HANDLING: If you encounter an error you cannot resolve in 2

&nbsp;  attempts, stop. Document the error, what you tried, and your hypothesis

&nbsp;  in PLAN.md. Do not loop indefinitely.



7\. NO SILENT ASSUMPTIONS: If the spec is ambiguous or a design decision is

&nbsp;  needed, stop and ask. Do not pick an interpretation and run with it.

&nbsp;  Surface tradeoffs and propose options.

8\. Checklist: For each task generate a checklist of small steps required to complete the task, double check the checklist before start implementation.