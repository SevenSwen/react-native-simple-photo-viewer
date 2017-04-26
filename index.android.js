import React, {Component, PropTypes} from 'react';
import ReactNative, {
    View,
    requireNativeComponent,
} from 'react-native';

import PhotoView from 'react-native-photo-view';

const resolveAssetSource = require('../react-native/Libraries/Image/resolveAssetSource');

class SimplePhotoView extends Component {
    render() {
        const source = resolveAssetSource(this.props.source) || { uri: undefined, width: undefined, height: undefined };

        return (
            <PhotoView
                source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}
                onLoad={() => console.log("onLoad called")}
                onTap={() => console.log("onTap called")}
                minimumZoomScale={0.5}
                maximumZoomScale={3}
                androidScaleType="center"
                style={this.props.style}/>
        );
    }
}

SimplePhotoView.propTypes = {
    source: PropTypes.any,
    minScaling: PropTypes.number,
    maxScaling: PropTypes.number,
    onDidExit: PropTypes.func,
    minAlpha: PropTypes.number,
    maxExitDistance: PropTypes.number,
    minExitVelocity: PropTypes.number
};

export default SimplePhotoView;
