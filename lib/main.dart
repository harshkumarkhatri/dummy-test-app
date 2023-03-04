import 'package:cash_rich_assignment/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/coin.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinRich',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Map<String, Coin>> coinData = ref.watch(coinStateFuture);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          "CoinRich",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xff363333),
        child: coinData.when(data: (data) {
          final coinsList = data.values.toList();
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.pie_chart_outline,
                        color: Color(0xfffae000),
                        size: 28,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      const Text(
                        "Show Chart",
                        style: TextStyle(
                          color: Color(0xfffae000),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Count: ${data.length}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 16);
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final currentCoin = coinsList[index];
                      // For no change, isEqual could be calculated
                      // and data could be shown accordingly
                      final isPositive =
                          (currentCoin.quote?.usd?.percentChange24h ?? 0) > 0;

                      final currentCoin24hPercentageChange =
                          "${currentCoin.quote?.usd?.percentChange24h?.abs().toStringAsFixed(2)}%";
                      final currentCoinPrice =
                          "\$ ${currentCoin.quote?.usd?.price?.toStringAsFixed(2) ?? ''}";
                      final currentCoinRank = "${currentCoin.cmcRank}";

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  currentCoin.name ?? '',
                                  style: const TextStyle(
                                    color: Color(
                                      0xfffae000,
                                    ),
                                    fontSize: 29,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 28,
                                ),
                                Icon(
                                  isPositive
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: isPositive ? Colors.green : Colors.red,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  currentCoin24hPercentageChange,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff363333),
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ),
                                  ),
                                  child: Text(
                                    currentCoin.symbol ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Price",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  currentCoinPrice,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "Rank",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  currentCoinRank,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                      0xfffae000,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward,
                                    size: 28,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: data.length,
                  ),
                ],
              ),
            ),
          );
        }, error: (error, stackTrace) {
          return Text("$error");
        }, loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
