import test from 'node:test';
import assert from 'node:assert/strict';
import {PLAYABLE_COUNTRIES, createInitialSnapshot} from './world_seed.js';

test('world seed contains the currently supported playable countries', () => {
  assert.equal(PLAYABLE_COUNTRIES.size, 44);
  for (const id of ['USA','FRA','TUR','LBN','RUS','CHN','IND','AUS']) assert.ok(PLAYABLE_COUNTRIES.has(id));
});

test('server owns the initial authoritative world snapshot', () => {
  const owners = new Map([['USA','player-a'],['TUR','player-b']]);
  const snapshot = createInitialSnapshot(owners);
  assert.equal(snapshot.turn, 1);
  assert.equal(Object.keys(snapshot.countries).length, PLAYABLE_COUNTRIES.size);
  assert.equal(snapshot.countries.USA.controller, 'P:USA');
  assert.equal(snapshot.countries.TUR.controller, 'P:TUR');
  assert.equal(snapshot.countries.FRA.controller, 'AI:FRA');
  assert.ok(snapshot.strategicSites.some((s) => s.id === 'USA_CAP'));
  assert.ok(snapshot.strategicSites.some((s) => s.id === 'LBN_PRT'));
  assert.equal(snapshot.countries.USA.commandPoints, 6);
  assert.equal(snapshot.countries.USA.techLogistics, 0);
  assert.equal(snapshot.countries.USA.warExhaustion, 0);
  assert.ok(snapshot.countries.USA.army.navy >= 1);
  assert.deepEqual(snapshot.events, []);
});
