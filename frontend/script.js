async function copyWebhook() {
  const url = document.getElementById("webhook-url").textContent;
  await navigator.clipboard.writeText(url);

  const btn = document.querySelector(".input-group .icon-btn");
  btn.style.background = "#f0f7ff";

  setTimeout(() => {
    btn.style.background = "";
  }, 1000);
}

async function analyzeRepo() {
  const input = document.getElementById("repo-input").value.trim();

  if (!input) return;

  const url = input.startsWith("http")
    ? input
    : "https://" + input;

  const status = document.getElementById("status-msg");

  status.textContent = "Analyzing...";

  try {

    const response = await fetch("/analyze", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        repo_url: url
      })
    });

    if (!response.ok) {
      throw new Error();
    }

    await loadResults();

    status.textContent = "Analysis complete.";

  } catch {

    status.textContent = "Analysis failed.";

  } finally {

    setTimeout(() => {
      status.textContent = "";
    }, 2000);

  }
}

function renderChecks(checks) {

  if (typeof checks === "string") {
    checks = JSON.parse(checks);
  }

  return checks.map(check => `
    <div class="check-item">
      <strong>${check.passed ? "✓" : "✗"} ${check.name}</strong>
      <p>${check.status}</p>
      ${
        check.recommendation
          ? `<p class="recommendation">
              Recommendation: ${check.recommendation}
             </p>`
          : ""
      }
    </div>
  `).join("");
}

function toggleDetails(id) {

  const row = document.getElementById(`details-${id}`);
  const icon = document.getElementById(`icon-${id}`);

  row.classList.toggle("open");

  icon.textContent = row.classList.contains("open")
    ? "▼"
    : "▶";
}

async function loadResults() {

  try {

    const res = await fetch("/results");
    const rows = await res.json();

    const tbody = document.getElementById("results-body");

    if (!rows.length) {

      tbody.innerHTML = `
        <tr class="empty-row">
          <td colspan="5">
            No analyses yet. Paste a repo above or push a commit.
          </td>
        </tr>
      `;

      return;
    }

    tbody.innerHTML = rows.map(row => {

      const [
        id,
        repo_url,
        score,
        timestamp,
        commit_message,
        passed_checks,
        checks
      ] = row;

      const repoName = repo_url.replace(
        "https://github.com/",
        ""
      );

      const dots = Array.from(
        { length: 7 },
        (_, i) =>
          `<span class="dot ${i < passed_checks ? "passed" : "failed"}"></span>`
      ).join("");

      return `
        <tr class="result-row" onclick="toggleDetails(${id})">

          <td class="repo-name">
            <span class="expand-icon" id="icon-${id}">▶</span>
            ${repoName}
          </td>

          <td class="score">${score}%</td>

          <td class="commit-name">
            ${commit_message || "—"}
          </td>

          <td>
            <div class="checks-dots">
              ${dots}
            </div>
          </td>

          <td>
            ${new Date(timestamp).toLocaleDateString()}
          </td>

        </tr>

        <tr
          id="details-${id}"
          class="details-row"
        >
          <td colspan="5">
            ${renderChecks(checks)}
          </td>
        </tr>
      `;

    }).join("");

  } catch {

    document.getElementById("results-body").innerHTML = `
      <tr class="empty-row">
        <td colspan="5">
          Unable to load analysis history.
        </td>
      </tr>
    `;

  }
}

document.getElementById("webhook-url").textContent =
  `${window.location.origin}/webhook`;

loadResults();