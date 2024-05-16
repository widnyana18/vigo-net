import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isp_app/common/widgets/error.dart';
import 'package:isp_app/features/catalog_product/controller/catalog_controller.dart';
import 'package:isp_app/features/order_product/controller/order_product_controller.dart';

class CatalogProductView extends ConsumerStatefulWidget {
  const CatalogProductView({Key? key}) : super(key: key);

  static const routeName = '/products';

  @override
  ConsumerState<CatalogProductView> createState() => _CatalogProductViewState();
}

class _CatalogProductViewState extends ConsumerState<CatalogProductView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _openCartDialog(CartNotifier cartNotifier) {
    if (cartNotifier.cartItems != []) {
      scaffoldKey.currentState?.showBottomSheet(
        (context) => Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey),
            ),
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('qty : ${cartNotifier.totalQtyProduct}'),
                      SizedBox(height: 8),
                      Text('Sub total : ${cartNotifier.subTotalPrice}'),
                    ],
                  ),
                  SizedBox(width: 20),
                  FilledButton(
                    onPressed: () {},
                    child: Text('Checkout'),
                  ),
                ],
              ),
            ),
          ),
        ),
        enableDrag: false,
        elevation: 2,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.watch(cartProvider);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Menu Products'),
        centerTitle: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TabBar(
              tabs: [
                Text('Paket Data'),
                Text('Addons'),
              ],
            ),
            Expanded(
              child: ref.watch(catalogDataAuthProvider).when(
                    data: (catalog) {
                      final internetList = catalog.internetData;
                      final addonsList = catalog.addonsData;

                      return TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: internetList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Text(
                                          internetList[index].title!,
                                          softWrap: true,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Rp ${internetList[index].price!}/bulan'),
                                          SizedBox(width: 20),
                                          FilledButton(
                                            onPressed: () {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .selectInternet(
                                                    internetId:
                                                        internetList[index].id!,
                                                    price: internetList[index]
                                                        .price!,
                                                  );

                                              _openCartDialog(cartNotifier);
                                            },
                                            style: FilledButton.styleFrom(
                                                backgroundColor:
                                                    cartNotifier.currentItems(
                                                                internetList[
                                                                        index]
                                                                    .id!) ==
                                                            null
                                                        ? Colors.blueGrey[600]
                                                        : Colors.orange),
                                            child: Text('BUY'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: addonsList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 65,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              'https://images.unsplash.com/photo-1606904825846-647eb07f5be2?q=80&w=870&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              addonsList[index].title!,
                                              softWrap: true,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    'Rp ${addonsList[index].price}/bulan'),
                                                SizedBox(width: 20),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: cartNotifier
                                                                  .getQtyProduct(
                                                                      addonsList[
                                                                              index]
                                                                          .id!) !=
                                                              0
                                                          ? () {
                                                              ref
                                                                  .read(cartProvider
                                                                      .notifier)
                                                                  .removeAddons(
                                                                      addonsList[
                                                                              index]
                                                                          .id!);

                                                              _openCartDialog(
                                                                  cartNotifier);
                                                            }
                                                          : null,
                                                      icon: Icon(Icons.remove),
                                                    ),
                                                    Text(
                                                      cartNotifier
                                                          .getQtyProduct(
                                                              addonsList[index]
                                                                  .id!)
                                                          .toString(),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        ref
                                                            .read(cartProvider
                                                                .notifier)
                                                            .addAddons(
                                                              addonsId:
                                                                  addonsList[
                                                                          index]
                                                                      .id!,
                                                              price: addonsList[
                                                                      index]
                                                                  .price!,
                                                            );

                                                        _openCartDialog(
                                                            cartNotifier);
                                                      },
                                                      icon: Icon(Icons.add),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    error: (err, trace) {
                      return ErrorView(error: err.toString());
                    },
                    loading: () => const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
