# shell.nix (Final Version)
let
  pkgs = import <nixpkgs> {};

  nodejs = pkgs.nodejs_22;
  pnpm = pkgs.nodePackages.pnpm;
  postgresql = pkgs.postgresql;
  git = pkgs.git;
  # Add Wrangler
  wrangler = pkgs.wrangler;
  
  # Python environment
  pythonEnv = pkgs.python39.withPackages (ps: with ps; [
    jupyter
    pandas
    numpy
    torch
    transformers
    umap-learn
    hdbscan
    matplotlib
    seaborn
    tqdm
    python-dotenv
    requests
    pip  # for installing additional packages
  ]);

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
    pythonEnv
  ];

  shellHook = ''
    echo "Entering meridian development environment..."
    # Optional: corepack enable pnpm
    echo "Node version: $(node --version)"
    echo "pnpm version: $(pnpm --version)"
    echo "PostgreSQL available: $(psql --version || echo 'Not found or server not running')"
    echo "Git version: $(git --version)"
    echo "Wrangler version: $(wrangler --version)"
    echo "Python version: $(python --version)"
    echo "Jupyter version: $(jupyter --version)"
    echo "-------------------------------------------------"
    echo "Installing additional Python packages..."
    pip install -U openai json-repair google-genai gliclass rapidfuzz retry ipywidgets widgetsnbextension pandas-profiling readtime optuna bertopic supabase
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