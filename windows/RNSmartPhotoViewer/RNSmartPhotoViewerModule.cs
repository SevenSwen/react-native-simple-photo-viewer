using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNSmartPhotoViewer
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNSmartPhotoViewerModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNSmartPhotoViewerModule"/>.
        /// </summary>
        internal RNSmartPhotoViewerModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNSmartPhotoViewer";
            }
        }
    }
}
