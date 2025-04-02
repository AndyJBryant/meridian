# shell.nix (Final Version)
let
  pkgs = import <nixpkgs> {};

  nodejs = pkgs.nodejs_22;
  pnpm = pkgs.nodePackages.pnpm;
  postgresql = pkgs.postgresql;
  git = pkgs.git;
  # Add Wrangler
  wrangler = pkgs.wrangler;

in
pkgs.mkShell {
  name = "meridian-dev-shell";

  buildInputs = [
    nodejs
    pnpm
    postgresql
    git
    # Add Wrangler
    wrangler
    # Removed python - Add back if you know you need it for a separate script/notebook
  ];

  shellHook = ''
    echo "Entering meridian development environment..."
    # Optional: corepack enable pnpm
    echo "Node version: $(node --version)"
    echo "pnpm version: $(pnpm --version)"
    echo "PostgreSQL available: $(psql --version || echo 'Not found or server not running')"
    echo "Git version: $(git --version)"
    echo "Wrangler version: $(wrangler --version)"
    echo "-------------------------------------------------"
    echo "Ensure configuration files are created and populated:"
    echo "  - packages/database/.env"
    echo "  - apps/scrapers/.dev.vars.local"
    echo "  - .env (in project root, optional but recommended for Nuxt SSR)"
    echo "Remember to set DATABASE_URL, SECRET_KEY, GOOGLE_AI_API_KEY."
    echo "Ensure PostgreSQL server is running."
    echo "-------------------------------------------------"
  '';
}