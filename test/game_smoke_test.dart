import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_dominion/main.dart';

void main() {
  test('world seed keeps the launch countries and required route data', () {
    final game = GameState();
    expect(game.countries.length, 44);
    expect(game.countries.containsKey('USA'), isTrue);
    expect(game.countries.containsKey('TUR'), isTrue);
    expect(game.countries.containsKey('LBN'), isTrue);
    expect(game.countries['TUR']!.neighbors, contains('GRC'));
    expect(game.countries['LBN']!.neighbors, contains('SYR'));
    expect(kAlpha3To2.length, game.countries.length);
    game.dispose();
  });

  test('naval invasion opens the requested USA to Europe route', () async {
    final game = GameState();
    await game.choose('USA');
    final britain = game.countries['GBR']!;
    final source = game.attackSourceFor('GBR');
    expect(source?.id, 'USA');
    expect(game.isNavalAttack(source!, britain), isTrue);
    expect(game.canNavalInvade(source, britain), isTrue);
    expect(game.attackCommandCost(source, britain, 'balanced'), 3);
    game.dispose();
  });

  test('gameplay systems start with command and research progression', () async {
    final game = GameState();
    await game.choose('FRA');
    expect(game.commandCap, 6);
    expect(game.techLevel('logistics'), 0);
    expect(game.me.warExhaustion, 0);
    expect(game.leaderboard, isNotEmpty);
    game.dispose();
  });


  test('frontline combat math is gradual and bounded', () {
    final even = frontlineProgressDelta(1, randomFactor: 0);
    final strong = frontlineProgressDelta(1.5, plan: 'breakthrough', encircled: true, randomFactor: 0);
    expect(even, greaterThan(0));
    expect(even, lessThan(30));
    expect(strong, greaterThan(even));
    expect(strong, lessThanOrEqualTo(48));
    expect(frontlineControlEdge(10, 2), greaterThan(0));
    expect(frontlineControlEdge(2, 10), lessThan(0));
  });

  test('battle state survives snapshot round-trip without breaking old saves', () {
    final game = GameState();
    game.battles.add(FrontBattle(id:'B1',source:'FRA',target:'DEU',attacker:'P:FRA',defender:'AI:DEU',progress:42,round:2,attackerArmyIds:['A1']));
    final snapshot = game.snapshot();
    final restored = GameState();
    restored.applySnapshot(snapshot);
    expect(restored.battles.length, 1);
    expect(restored.battles.first.progress, 42);
    restored.applySnapshot({'countries': <String,dynamic>{}});
    expect(restored.battles, isEmpty);
    game.dispose();restored.dispose();
  });

  test('v1.4 pace changes strategic tempo while preserving campaign defaults', () async {
    final game = GameState();
    await game.choose('FRA');
    expect(game.commandCap, 6);
    game.setGamePace('rapid');
    expect(game.commandCap, 8);
    expect(game.hegemonyStartTurn, 15);
    game.setGamePace('grand');
    expect(game.commandCap, 5);
    expect(game.recommendedTurnMinutes, 720);
    game.dispose();
  });

  test('v1.4 provinces keep logistics and bilingual labels in snapshots', () {
    final game = GameState();
    final p = game.provinces.first;
    expect(p.supply, greaterThan(0));
    expect(p.infrastructure, greaterThan(0));
    final snapshot = game.snapshot();
    final restored = GameState();
    restored.applySnapshot(snapshot);
    expect(restored.provinces.first.supply, p.supply);
    restored.setLanguage('en');
    expect(restored.tr('هجوم','Attack'), 'Attack');
    game.dispose();restored.dispose();
  });

  testWidgets('launch screen exposes local and online entry points', (tester) async {
    await tester.pumpWidget(const WorldDominionApp());
    expect(find.text('WORLD DOMINION'), findsOneWidget);
    expect(find.text('مباراة أونلاين'), findsOneWidget);
    expect(find.byIcon(Icons.public), findsOneWidget);
  });
}
