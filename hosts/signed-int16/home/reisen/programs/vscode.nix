{ pkgs, inputs, ... } : let
  inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
in {
  home.packages = with pkgs; [ python3Full ];
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;
    enableUpdateCheck = false;
    mutableExtensionsDir = true;
    userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.cursorStyle" = "block";
      "editor.smoothScrolling" = true;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "workbench.list.smoothScrolling" = true;
      "window.menuBarVisibility" = "toggle";
      "terminal.integrated.smoothScrolling" = true;
    };
    extensions = with vscode-marketplace; [
      ms-python.python
      yzhang.markdown-all-in-one
      mkhl.direnv
      ms-vscode.hexeditor
      zhuangtongfa.material-theme
      bbenoist.nix
      kamadorueda.alejandra
      pkief.material-icon-theme
      shalldie.background
    ];
  };
}
