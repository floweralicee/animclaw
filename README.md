<p align="center">
  <a href="https://animclaw.com">
    <img src="assets/animclaw-hero.png" alt="AnimClaw — AI CRM, hosted locally on your Mac. Built on OpenClaw." width="680" />
  </a>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/animclaw"><img src="https://img.shields.io/npm/v/animclaw?style=for-the-badge&color=000" alt="npm version"></a>&nbsp;
  <a href="https://discord.gg/PDFXNVQj9n"><img src="https://img.shields.io/discord/1456350064065904867?label=Discord&logo=discord&logoColor=white&color=5865F2&style=for-the-badge" alt="Discord"></a>&nbsp;
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="MIT License"></a>
</p>

<p align="center">
  <a href="https://animclaw.com">Website</a> · <a href="https://discord.gg/PDFXNVQj9n">Discord</a> · <a href="https://skills.sh">Skills Store</a> · <a href="https://www.youtube.com/watch?v=pfACTbc3Bh4&t=44s">Demo Video</a>
</p>

<br />

<p align="center">
  <a href="https://animclaw.com">
    <img src="assets/animclaw-app.png" alt="AnimClaw Web UI — workspace, object tables, and AI chat" width="780" />
  </a>
  <br />
  <a href="https://www.youtube.com/watch?v=pfACTbc3Bh4&t=44s">Demo Video</a> · <a href="https://discord.gg/PDFXNVQj9n">Join our Discord Server</a>
</p>

<br />

## Install

**Node 22+ required.**

```bash
npx animclaw
```

Opens at `localhost:3100` after completing onboarding wizard.

---

## Commands

```bash
npx animclaw # runs onboarding again for openclaw --profile animclaw
npx animclaw update # updates animclaw with current settings as is
npx animclaw restart # restarts animclaw web server
npx animclaw start # starts animclaw web server
npx animclaw stop # stops animclaw web server

# some examples
openclaw --profile animclaw <any openclaw command>
openclaw --profile animclaw gateway restart

openclaw --profile animclaw config set gateway.port 19001
openclaw --profile animclaw gateway install --force --port 19001
openclaw --profile animclaw gateway restart
openclaw --profile animclaw uninstall
```

---

## Development

```bash
git clone https://github.com/AnimClaw/AnimClaw.git
cd animclaw

pnpm install
pnpm build

pnpm dev
```

Web UI development:

```bash
pnpm install
pnpm web:dev
```

---

## Open Source

MIT Licensed. Fork it, extend it, make it yours.

<p align="center">
  <a href="https://star-history.com/?repos=AnimClaw%2FAnimClaw&type=date&legend=top-left">
    <img src="https://api.star-history.com/image?repos=AnimClaw/AnimClaw&type=date&legend=top-left" alt="Star History" width="620" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/AnimClaw/AnimClaw"><img src="https://img.shields.io/github/stars/AnimClaw/AnimClaw?style=for-the-badge" alt="GitHub stars"></a>
</p>
