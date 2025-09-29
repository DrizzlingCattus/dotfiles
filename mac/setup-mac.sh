#!/usr/bin/env bash

echo "[Finder] '경로 막대 보기' 설정 값을 true로 설정합니다."
defaults write com.apple.finder ShowPathbar -bool true
echo "[Finder] '상태 막대 보기' 설정 값을 true로 설정합니다."
defaults write com.apple.finder ShowStatusBar -bool true
echo "[Finder] '미리보기' 설정 값을 true로 설정합니다."
defaults write com.apple.finder ShowPreviewPane -bool true

echo "[Keyboard] 키를 길게 눌렀을때, 반복입력되도록 합니다. (true는 악센트창 띄움)"
defaults write -g ApplePressAndHoldEnabled -bool false
