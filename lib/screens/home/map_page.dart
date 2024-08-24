import 'dart:async';

import 'package:ecoville/blocs/app/location_cubit.dart';
import 'package:ecoville/blocs/app/product_cubit.dart';
import 'package:ecoville/screens/home/home_page.dart';
import 'package:ecoville/shared/icon_container.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    addMarker(
      LatLng position,
      String id,
      String name,
      bool isMyLocation,
    ) {
      MarkerId markerId = MarkerId(id);
      Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarkerWithHue(
            isMyLocation ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed),
        position: position,
        infoWindow: InfoWindow(
            title: name,
            snippet: isMyLocation ? 'Your location' : 'Tap to view product',
            onTap: () => isMyLocation
                ? null
                : context.push('/home/details/$id', extra: {
                    'title': name,
                  })),
        onTap: () =>
            context.read<ProductCubit>().getSimilarProducts(productId: id),
      );
      markers[markerId] = marker;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocConsumer<ProductCubit, ProductState>(
                buildWhen: (previous, current) =>
                    previous.products != current.products,
                bloc: context.read<ProductCubit>()
                  ..getProducts()
                  ..getNearbyProducts(),
                  
                listener: (context, state) {
                  if (state.status == ProductStatus.success) {
                    for (var element in state.products) {
                      addMarker(
                        LatLng(
                          double.tryParse(element.address?.lat.toString() ?? "0.0") ?? 0.0,
                          double.tryParse(element.address?.lon.toString() ?? "0.0") ?? 0.0,
                        ),
                        element.id,
                        element.name,
                        false,
                      );
                    }
                    logger.d('Markers: $markers');
                  }
                },
                builder: (context, state) {
                  return BlocBuilder<LocationCubit, LocationState>(
                    // buildWhen: (previous, current) =>
                    //     previous.position != current.position,
                    bloc: context.read<LocationCubit>()..getCurrentLocation(),
                    builder: (context, state) {
                      
                      return Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: GoogleMap(
                              gestureRecognizers: <Factory<
                                  OneSequenceGestureRecognizer>>{
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                              mapType: MapType.terrain,
                              myLocationButtonEnabled: true,
                              myLocationEnabled: false,
                              tiltGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              onCameraIdle: () {
                                print('Camera idle');
                              },
                              onCameraMove: (CameraPosition position) {},
                              compassEnabled: false,
                              indoorViewEnabled: true,
                              zoomGesturesEnabled: true,
                              circles: <Circle>{
                                Circle(
                                  circleId: const CircleId('1'),
                                  center: LatLng(state.position!.latitude,
                                      state.position!.longitude),
                                  radius: NEARBY_RADIUS,
                                  fillColor: green.withOpacity(0.1),
                                  strokeWidth: 0,
                                ),
                              },
                              markers: Set<Marker>.of(markers.values),
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(-0.3942691,
                                    36.9630827),
                                zoom: 15,
                              ),
                              onMapCreated:
                                  (GoogleMapController controller) async {
                                    logger.d('Current location emilio: ${state.position!.latitude}, ${state.position!.longitude}');
                                final GoogleMapController controller =
                                    await _controller.future;
                                controller.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                        LatLng(state.position!.latitude,
                                            state.position!.longitude),
                                        15));

                                _controller.complete(controller);
                              },
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top,
                            left: 20,
                            child: IconContainer(
                                icon: AppImages.close,
                                function: () => context.pop()),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              // const RecommendedItems(),
              const RecentItems(),
            ],
          ),
        ));
  }
}
