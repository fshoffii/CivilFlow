import 'pemohon.dart';
import 'status_layanan.dart';

class SistemAntreanMPP<K, T extends Pemohon> {

  // Map
  final Map<K, T> _storageMap = {};

  // List (Queue FIFO)
  final List<K> _indexOrder = [];

  // Set (Riwayat pelayanan unik)
  final Set<K> _riwayatPelayanan = {};

  void registrasiAntrean(K key, T warga) {
    if (_storageMap.containsKey(key)) {
      print('Gagal: NIK [$key] atas nama ${warga.namaLengkap} sudah terdaftar di loket aktif Mall Pelayanan Publik!');
      return;
    }

    _storageMap[key] = warga;
    _indexOrder.add(key);

    print('Sukses: Karcis dicetak untuk ${warga.namaLengkap} (ID-NIK: $key)');
  }

  /// Queue FIFO
  void panggilAntreanBerikutnya() {
    if (_indexOrder.isEmpty) {
      print('Monitor: Semua loket kosong. Seluruh pemohon hari ini telah dilayani.');
      return;
    }

    K keyTerdepan = _indexOrder.removeAt(0);
    T pemohonSekarang = _storageMap[keyTerdepan]!;

    print('\n==================================================');
    print('PANGGILAN LOKET: NIK [$keyTerdepan] - ${pemohonSekarang.namaLengkap}');
    print('Akses Alur     : ${pemohonSekarang.dapatkanJalurLayanan()}');

    pemohonSekarang.status = StatusLayanan.SEDANG_DILAYANI;

    // Simpan ke Set (riwayat pelayanan)
    _riwayatPelayanan.add(keyTerdepan);

    _storageMap.remove(keyTerdepan);

    print('STATUS OPERATOR: Pemohon sedang diarahkan menuju meja pelayanan.');
    print('==================================================');
  }

  /// Menampilkan riwayat pelayanan
  void tampilkanRiwayatPelayanan() {
    print('\n--- RIWAYAT PELAYANAN ---');

    if (_riwayatPelayanan.isEmpty) {
      print('Belum ada pemohon yang dilayani.');
    } else {
      for (var nik in _riwayatPelayanan) {
        print('NIK: $nik');
      }
    }

    print('-------------------------\n');
  }

  void lacakPemohonViaNIK(K key) {
    print('\n[ Pemindaian Sistem] Mencari NIK: $key');

    if (_storageMap.containsKey(key)) {
      T pemohon = _storageMap[key]!;

      print('Hasil: Pemohon ditemukan! Posisi: Sedang Menunggu di Ruang Tunggu.');
      pemohon.cetakKarcis();
    } else {
      print('Hasil: NIK tidak aktif (Mungkin salah input / sudah selesai dilayani).');
    }
  }

  void tampilkanMonitorLayarUtama() {
    print('\n--- MONITOR DIGITAL RUANG TUNGGU ---');

    if (_indexOrder.isEmpty) {
      print('Tidak ada antrean aktif saat ini.');
    } else {
      int urutan = 1;

      for (var key in _indexOrder) {
        var pemohon = _storageMap[key]!;

        print('$urutan. Nomor NIK: $key | Nama: ${pemohon.namaLengkap}');
        urutan++;
      }
    }

    print('-------------------------------------------\n');
  }
}