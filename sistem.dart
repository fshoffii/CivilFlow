import 'pemohon.dart';
import 'status_layanan.dart';

class SistemAntreanMPP<K, T extends Pemohon> {
  // 1. Map (Pencarian cepat key-value)
  final Map<K, T> _storageMap = {};
  
  // 2. List Bertindak Sebagai Queue (Prinsip FIFO)
  final List<K> _indexOrder = [];
  
  // 3. Set (Riwayat pelayanan unik, mencegah duplikasi NIK)
  final Set<K> _riwayatPelayanan = {};

  // 4. List Bertindak Sebagai Stack (Prinsip LIFO untuk Fitur Undo)
  final List<K> _stackPanggilanTerakhir = [];

  /// Registrasi Antrean (Enqueue & Menambahkan ke Storage)
  void registrasiAntrean(K key, T warga) {
    if (_storageMap.containsKey(key)) { // Konsep searching data aktif
      print('Gagal: NIK [$key] atas nama ${warga.namaLengkap} sudah terdaftar di loket aktif Mall Pelayanan Publik!');
      return;
    }

    _storageMap[key] = warga;
    _indexOrder.add(key); // Enqueue (masuk ujung antrean)

    print('Sukses: Karcis dicetak untuk ${warga.namaLengkap} (ID-NIK: $key)');
  }

  /// Memanggil Antrean Berikutnya (Dequeue & Push ke Stack)
  void panggilAntreanBerikutnya() {
    if (_indexOrder.isEmpty) {
      print('Monitor: Semua loket kosong. Seluruh pemohon hari ini telah dilayani.');
      return;
    }

    K keyTerdepan = _indexOrder.removeAt(0); // Dequeue (Ambil elemen terdepan / FIFO)
    T pemohonSekarang = _storageMap[keyTerdepan]!;

    // PUSH: Simpan data yang baru dipanggil ke dalam Stack sebelum statusnya diproses lanjut
    _stackPanggilanTerakhir.add(keyTerdepan);

    print('\n==================================================');
    print('PANGGILAN LOKET: NIK [$keyTerdepan] - ${pemohonSekarang.namaLengkap}');
    print('Akses Alur     : ${pemohonSekarang.dapatkanJalurLayanan()}');
    pemohonSekarang.status = StatusLayanan.SEDANG_DILAYANI;

    // Simpan ke Set (riwayat pelayanan unik)
    _riwayatPelayanan.add(keyTerdepan);
    
    // CATATAN: Jika _storageMap.remove(keyTerdepan) langsung dijalankan di sini, 
    // fitur undoPanggilanLoket() akan error/bug karena datanya hilang dari map.
    // Oleh karena itu, penghapusan dari _storageMap idealnya dilakukan setelah pelayanan benar-benar SELESAI.
    
    print('STATUS OPERATOR: Pemohon sedang diarahkan menuju meja pelayanan.');
    print('==================================================');
  }

  //Fitur Undo Panggilan (Pop dari Stack & Insert ke index 0 pada Queue)
  void undoPanggilanLoket() {
    if (_stackPanggilanTerakhir.isEmpty) {
      print('Sistem: Tidak ada aksi panggilan yang bisa dibatalkan.');
      return;
    }

    // POP: Ambil data terakhir yang masuk ke dalam Stack (LIFO)
    K keyDibatalkan = _stackPanggilanTerakhir.removeLast();
    
    // Kembalikan data pemohon ke antrean paling depan (Indeks 0)
    _indexOrder.insert(0, keyDibatalkan);

    // Hapus dari riwayat karena panggilan dibatalkan
    _riwayatPelayanan.remove(keyDibatalkan);

    T pemohon = _storageMap[keyDibatalkan]!;
    pemohon.status = StatusLayanan.MENUNGGU; // Reset status ke menunggu

    print('\n Panggilan untuk pemanggilan atas nama ${pemohon.namaLengkap}  .');
    print('Sistem: Pemohon telah dikembalikan ke barisan depan antrean.');
  }

  /// Menampilkan Riwayat Pelayanan (Membaca data Set)
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

  /// Lacak Pemohon Via NIK (Konsep Searching pada Map)
  void lacakPemohonViaNIK(K key) {
    print('\n[Pemindaian Sistem] Mencari NIK: $key');

    if (_storageMap.containsKey(key)) { // Searching data terdaftar
      T pemohon = _storageMap[key]!;

      print('Hasil: Pemohon ditemukan! Posisi: Sedang Menunggu di Ruang Tunggu.');
      pemohon.cetakKarcis();
    } else {
      print('Hasil: NIK tidak aktif (Mungkin salah input / sudah selesai dilayani).');
    }
  }

  /// Menampilkan Monitor Layar Utama (Membaca data List Queue)
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
