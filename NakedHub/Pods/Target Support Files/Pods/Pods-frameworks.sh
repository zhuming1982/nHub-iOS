#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

SWIFT_STDLIB_PATH="${DT_TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"

install_framework()
{
  if [ -r "${BUILT_PRODUCTS_DIR}/$1" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$1"
  elif [ -r "${BUILT_PRODUCTS_DIR}/$(basename "$1")" ]; then
    local source="${BUILT_PRODUCTS_DIR}/$(basename "$1")"
  elif [ -r "$1" ]; then
    local source="$1"
  fi

  local destination="${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

  if [ -L "${source}" ]; then
      echo "Symlinked..."
      source="$(readlink "${source}")"
  fi

  # use filter instead of exclude so missing patterns dont' throw errors
  echo "rsync -av --filter \"- CVS/\" --filter \"- .svn/\" --filter \"- .git/\" --filter \"- .hg/\" --filter \"- Headers\" --filter \"- PrivateHeaders\" --filter \"- Modules\" \"${source}\" \"${destination}\""
  rsync -av --filter "- CVS/" --filter "- .svn/" --filter "- .git/" --filter "- .hg/" --filter "- Headers" --filter "- PrivateHeaders" --filter "- Modules" "${source}" "${destination}"

  local basename
  basename="$(basename -s .framework "$1")"
  binary="${destination}/${basename}.framework/${basename}"
  if ! [ -r "$binary" ]; then
    binary="${destination}/${basename}"
  fi

  # Strip invalid architectures so "fat" simulator / device frameworks work on device
  if [[ "$(file "$binary")" == *"dynamically linked shared library"* ]]; then
    strip_invalid_archs "$binary"
  fi

  # Resign the code if required by the build settings to avoid unstable apps
  code_sign_if_enabled "${destination}/$(basename "$1")"

  # Embed linked Swift runtime libraries. No longer necessary as of Xcode 7.
  if [ "${XCODE_VERSION_MAJOR}" -lt 7 ]; then
    local swift_runtime_libs
    swift_runtime_libs=$(xcrun otool -LX "$binary" | grep --color=never @rpath/libswift | sed -E s/@rpath\\/\(.+dylib\).*/\\1/g | uniq -u  && exit ${PIPESTATUS[0]})
    for lib in $swift_runtime_libs; do
      echo "rsync -auv \"${SWIFT_STDLIB_PATH}/${lib}\" \"${destination}\""
      rsync -auv "${SWIFT_STDLIB_PATH}/${lib}" "${destination}"
      code_sign_if_enabled "${destination}/${lib}"
    done
  fi
}

# Signs a framework with the provided identity
code_sign_if_enabled() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" -a "${CODE_SIGNING_REQUIRED}" != "NO" -a "${CODE_SIGNING_ALLOWED}" != "NO" ]; then
    # Use the current code_sign_identitiy
    echo "Code Signing $1 with Identity ${EXPANDED_CODE_SIGN_IDENTITY_NAME}"
    echo "/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements \"$1\""
    /usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements "$1"
  fi
}

# Strip invalid architectures
strip_invalid_archs() {
  binary="$1"
  # Get architectures for current file
  archs="$(lipo -info "$binary" | rev | cut -d ':' -f1 | rev)"
  stripped=""
  for arch in $archs; do
    if ! [[ "${VALID_ARCHS}" == *"$arch"* ]]; then
      # Strip non-valid architectures in-place
      lipo -remove "$arch" -output "$binary" "$binary" || exit 1
      stripped="$stripped $arch"
    fi
  done
  if [[ "$stripped" ]]; then
    echo "Stripped $binary of architectures:$stripped"
  fi
}


if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework "Pods/AFNetworking.framework"
  install_framework "Pods/AMAttributedHighlightLabel.framework"
  install_framework "Pods/APAddressBook.framework"
  install_framework "Pods/BEMCheckBox.framework"
  install_framework "Pods/BFPaperCheckbox.framework"
  install_framework "Pods/BlocksKit.framework"
  install_framework "Pods/DACircularProgress.framework"
  install_framework "Pods/DZNEmptyDataSet.framework"
  install_framework "Pods/DateTools.framework"
  install_framework "Pods/ESConveyorBelt.framework"
  install_framework "Pods/FDStackView.framework"
  install_framework "Pods/FMDB.framework"
  install_framework "Pods/FrameAccessor.framework"
  install_framework "Pods/HMSegmentedControl.framework"
  install_framework "Pods/HexColors.framework"
  install_framework "Pods/JSBadgeView.framework"
  install_framework "Pods/JTSImageViewController.framework"
  install_framework "Pods/LMDropdownView.framework"
  install_framework "Pods/M13ProgressSuite.framework"
  install_framework "Pods/MBAutoGrowingTextView.framework"
  install_framework "Pods/MBProgressHUD.framework"
  install_framework "Pods/MTDates.framework"
  install_framework "Pods/MWPhotoBrowser.framework"
  install_framework "Pods/Mantle.framework"
  install_framework "Pods/Mixpanel.framework"
  install_framework "Pods/NSString_Hashes.framework"
  install_framework "Pods/RBStoryboardLink.framework"
  install_framework "Pods/RMActionController.framework"
  install_framework "Pods/RMDateSelectionViewController.framework"
  install_framework "Pods/RMPickerViewController.framework"
  install_framework "Pods/ReactiveCocoa.framework"
  install_framework "Pods/ReactiveViewModel.framework"
  install_framework "Pods/RegexKitLite.framework"
  install_framework "Pods/SDWebImage.framework"
  install_framework "Pods/SKTagView.framework"
  install_framework "Pods/STTweetLabel.framework"
  install_framework "Pods/SVWebViewController.framework"
  install_framework "Pods/SYFavoriteButton.framework"
  install_framework "Pods/SZTextView.framework"
  install_framework "Pods/TPKeyboardAvoiding.framework"
  install_framework "Pods/TTTAttributedLabel.framework"
  install_framework "Pods/UIColor_BFPaperColors.framework"
  install_framework "Pods/UIColor_ColorWithHexAndAlpha.framework"
  install_framework "Pods/UITableView_FDTemplateLayoutCell_Bell.framework"
  install_framework "Pods/XLForm.framework"
  install_framework "Pods/YYKit.framework"
  install_framework "Pods/iCarousel.framework"
  install_framework "Pods/libextobjc.framework"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework "Pods/AFNetworking.framework"
  install_framework "Pods/AMAttributedHighlightLabel.framework"
  install_framework "Pods/APAddressBook.framework"
  install_framework "Pods/BEMCheckBox.framework"
  install_framework "Pods/BFPaperCheckbox.framework"
  install_framework "Pods/BlocksKit.framework"
  install_framework "Pods/DACircularProgress.framework"
  install_framework "Pods/DZNEmptyDataSet.framework"
  install_framework "Pods/DateTools.framework"
  install_framework "Pods/ESConveyorBelt.framework"
  install_framework "Pods/FDStackView.framework"
  install_framework "Pods/FMDB.framework"
  install_framework "Pods/FrameAccessor.framework"
  install_framework "Pods/HMSegmentedControl.framework"
  install_framework "Pods/HexColors.framework"
  install_framework "Pods/JSBadgeView.framework"
  install_framework "Pods/JTSImageViewController.framework"
  install_framework "Pods/LMDropdownView.framework"
  install_framework "Pods/M13ProgressSuite.framework"
  install_framework "Pods/MBAutoGrowingTextView.framework"
  install_framework "Pods/MBProgressHUD.framework"
  install_framework "Pods/MTDates.framework"
  install_framework "Pods/MWPhotoBrowser.framework"
  install_framework "Pods/Mantle.framework"
  install_framework "Pods/Mixpanel.framework"
  install_framework "Pods/NSString_Hashes.framework"
  install_framework "Pods/RBStoryboardLink.framework"
  install_framework "Pods/RMActionController.framework"
  install_framework "Pods/RMDateSelectionViewController.framework"
  install_framework "Pods/RMPickerViewController.framework"
  install_framework "Pods/ReactiveCocoa.framework"
  install_framework "Pods/ReactiveViewModel.framework"
  install_framework "Pods/RegexKitLite.framework"
  install_framework "Pods/SDWebImage.framework"
  install_framework "Pods/SKTagView.framework"
  install_framework "Pods/STTweetLabel.framework"
  install_framework "Pods/SVWebViewController.framework"
  install_framework "Pods/SYFavoriteButton.framework"
  install_framework "Pods/SZTextView.framework"
  install_framework "Pods/TPKeyboardAvoiding.framework"
  install_framework "Pods/TTTAttributedLabel.framework"
  install_framework "Pods/UIColor_BFPaperColors.framework"
  install_framework "Pods/UIColor_ColorWithHexAndAlpha.framework"
  install_framework "Pods/UITableView_FDTemplateLayoutCell_Bell.framework"
  install_framework "Pods/XLForm.framework"
  install_framework "Pods/YYKit.framework"
  install_framework "Pods/iCarousel.framework"
  install_framework "Pods/libextobjc.framework"
fi