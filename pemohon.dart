import 'status_layanan.dart';

/// Sebagai cetak biru untuk seluruh warga/pemohon yang datang ke mall pelayanan.
abstract class Pemohon {
  //Encapsulation Atribut diisolasi menggunakan private (_)
  String _nik; // Diisolasi agar tidak bisa dimanipulasi ilegal dari luar class
  String _namaLengkap;
  StatusLayanan status;

  Pemohon(this._nik, this._namaLengkap) : status = StatusLayanan.MENUNGGU;

  // Getter resmi untuk mengakses data terenkapsulasi
  String get nik => _nik;
  String get namaLengkap => _namaLengkap;

  /// Polimorfisme: Method abstrak untuk menentukan jalur loket layanan spesifik
  String dapatkanJalurLayanan();

  void cetakKarcis() {
    print('[$_nik] $_namaLengkap | Status Saat Ini: ${status.name}');
  }
}


/// Inheritanse & Polymorphsim
/// Kategori warga lanjut usia atau disabilitas yang berhak atas jalur cepat Loket Prioritas.
class PemohonPrioritas extends Pemohon {
  String kategoriKhusus; // Contoh: "Lansia 75 Tahun" atau "Ibu Menyusui"
  
  PemohonPrioritas(String nik, String nama, this.kategoriKhusus) : super(nik, nama);

  /// Overriding Method (Polymorphism) -> Mengubah jalur menuju Fast-Track khusus
  @override
  String dapatkanJalurLayanan() {
    return 'Jalur Fast-Track (Loket Khusus Prioritas $kategoriKhusus - Tanpa Menunggu Lama)';
  }
}

/// Kategori warga umum yang diproses melalui loket reguler berdasarkan FIFO.
class PemohonReguler extends Pemohon {
  PemohonReguler(String nik, String nama) : super(nik, nama);

  /// Overriding Method (Polymorphism) -> Menggunakan jalur standar MPP
  @override
  String dapatkanJalurLayanan() {
    return 'Jalur Standar (Loket Reguler - Sesuai Urutan Kedatangan)';
  }
}