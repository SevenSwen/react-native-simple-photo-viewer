import React, {Component, PropTypes} from 'react';
import ReactNative, {
    requireNativeComponent,
} from 'react-native';

const resolveAssetSource = require('../react-native/Libraries/Image/resolveAssetSource');

class SimplePhotoView extends Component {
    _onDidExit() {
        if (!this.props.onDidExit) {
            return;
        }

        this.props.onDidExit();
    }

    render() {
        const source = resolveAssetSource(this.props.source) || { uri: undefined, width: undefined, height: undefined };
        let sources;
        if (Array.isArray(source)) {
            sources = source;
        } else {
            const {width, height, uri} = source;
            sources = [source];

            if (uri === '') {
                console.warn('source.uri should not be an empty string');
            }
        }

        return (
            <RNSimplePhotoView
                {...this.props}
                source={sources}
                onDidExit={this._onDidExit.bind(this)}
            />
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

var RNSimplePhotoView = requireNativeComponent('RNSimplePhotoView', SimplePhotoView);

export default SimplePhotoView;