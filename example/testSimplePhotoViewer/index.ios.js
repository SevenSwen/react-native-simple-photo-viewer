'use strict';

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Image,
    TouchableOpacity,
    Dimensions,
    requireNativeComponent
} from 'react-native';

import SimplePhotoView from 'react-native-simple-photo-viewer';


export default class testSimplePhotoViewer extends Component {
    state = {
        openedImage: null,
        pageHeight: Dimensions.get('window').height,
        pageWidth: Dimensions.get('window').width
    };

    _onPressButton = (image) => {
        this.setState({openedImage: image});
    };

    getNewDimensions = (event) => {
        this.setState({
            pageHeight: event.nativeEvent.layout.height,
            pageWidth: event.nativeEvent.layout.width
        })
    };

    render() {
        const imageLenna = require("./Lenna.png");
        const imageLenna_horizontal = require("./Lenna_horizontal.jpg");
        const imageLenna_vertical = require("./Lenna_vertical.jpg");

        return (
        <View
            style={styles.container}
            onLayout={this.getNewDimensions}>
            <TouchableOpacity onPress={() => this._onPressButton(imageLenna)}>
                <Image
                    source={imageLenna}
                    style={styles.image}
                />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => this._onPressButton(imageLenna_horizontal)}>
                <Image
                    source={imageLenna_horizontal}
                    style={styles.image}
                />
            </TouchableOpacity>
            <TouchableOpacity onPress={() => this._onPressButton(imageLenna_vertical)}>
                <Image
                    source={imageLenna_vertical}
                    style={styles.image}
                />
            </TouchableOpacity>
            {this.state.openedImage &&
                <SimplePhotoView
                    style={[styles.photoView,
                            {width: this.state.pageWidth,
                            height: this.state.pageHeight}]}
                    source={this.state.openedImage}
                    onDidExit={() => {
                        this.setState({openedImage: null});
                    }}
                />
            }
        </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center'
    },
    image: {
        width: 50,
        height: 50
    },
    photoView: {
        position: 'absolute',
        top: 0,
        left: 0
    }
});

AppRegistry.registerComponent('testSimplePhotoViewer', () => testSimplePhotoViewer);
