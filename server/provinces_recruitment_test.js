import test from 'node:test';
import assert from 'node:assert/strict';
import { createInitialSnapshot, PLAYABLE_COUNTRIES } from './world_seed.js';

test('v1.3 seed preserves old countries and adds province state',()=>{
 const snap=createInitialSnapshot(new Map([['USA','p1']]));
 assert.ok(PLAYABLE_COUNTRIES.has('USA'));
 assert.ok(PLAYABLE_COUNTRIES.has('TUR'));
 assert.ok(Array.isArray(snap.provinces));
 assert.ok(snap.provinces.some(p=>p.countryId==='USA'));
 assert.equal(snap.countries.USA.controller,'P:USA');
 assert.ok(Number(snap.countries.USA.stock.gold)>=0);
 assert.equal(Number(snap.countries.USA.trainingCamps),0);
 assert.equal(Number(snap.countries.USA.borderDefense),0);
});

test('province ids are unique in generated seed',()=>{
 const snap=createInitialSnapshot(new Map());const ids=snap.provinces.map(p=>p.id);assert.equal(new Set(ids).size,ids.length);
});
