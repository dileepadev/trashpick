import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class UUIDGenerator {
  // Generate a v1 (time-based) id  -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'
  String uuidV1() {
    var uuid = Uuid();
    var v1 = uuid.v1();

    return v1.toString();
  }

  // Generate a v1Exact -> '710b962e-041c-11e1-9234-0123456789ab'
  String uuidV1Exact() {
    var uuid = Uuid();
    var v1Exact = uuid.v1(options: {
      'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      'clockSeq': 0x1234,
      'mSecs': DateTime.utc(2011, 11, 01).millisecondsSinceEpoch,
      'nSecs': 5678
    });

    return v1Exact.toString();
  }

  // Generate a v4 (random) id  -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
  String uuidV4() {
    var uuid = Uuid();
    var v4 = uuid.v4();

    return v4.toString();
  }

  // Generate a v4 (crypto-random) id  -> '110ec58a-a0f2-4ac4-8393-c866d813b8d1'
  String uuidV4Crypto() {
    var uuid = Uuid();
    var v4Crypto = uuid.v4(options: {'rng': UuidUtil.cryptoRNG});

    return v4Crypto.toString();
  }

  // Generate a v5 (namespace-name-sha1-based) id  -> 'c74a196f-f19d-5ea9-bffd-a2742432fc9c'
  String uuidV5() {
    var uuid = Uuid();
    var v5 = uuid.v5(Uuid.NAMESPACE_URL, 'www.google.com');

    return v5.toString();
  }
}
