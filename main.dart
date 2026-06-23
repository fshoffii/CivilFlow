import 'dart:io';
import 'pemohon.dart';
import 'sistem.dart';

void main() {
  var sistem = SistemAntreanMPP<String, Pemohon>();

  while (true) {
    print('\n========== CIVILFLOW ==========');
    print('1. Registrasi Pemohon');
    print('2. Panggil Antrean Berikutnya');
    print('3. Lacak Pemohon via NIK');
    print('4. Tampilkan Monitor Antrean');
    print('5. Tampilkan Riwayat Pelayanan');
    print('6. Cancel Panggilan Terakhir');
    print('0. Keluar');
    print('================================');

    stdout.write('Pilih menu: ');
    String pilihan = stdin.readLineSync() ?? '';

    switch (pilihan) {
      case '1':
        stdout.write('Masukkan NIK: ');
        String nik = stdin.readLineSync() ?? '';

        stdout.write('Masukkan Nama: ');
        String nama = stdin.readLineSync() ?? '';

        stdout.write('Jenis Pemohon (1=Reguler, 2=Prioritas): ');
        String jenis = stdin.readLineSync() ?? '';

        if (jenis == '2') {
          stdout.write('Kategori Prioritas: ');
          String kategori = stdin.readLineSync() ?? '';

          sistem.registrasiAntrean(
            nik,
            PemohonPrioritas(nik, nama, kategori),
          );
        } else {
          sistem.registrasiAntrean(
            nik,
            PemohonReguler(nik, nama),
          );
        }
        break;

      case '2':
        sistem.panggilAntreanBerikutnya();
        break;

      case '3':
        stdout.write('Masukkan NIK yang dicari: ');
        String nikCari = stdin.readLineSync() ?? '';
        sistem.lacakPemohonViaNIK(nikCari);
        break;

      case '4':
        sistem.tampilkanMonitorLayarUtama();
        break;

      case '5':
        sistem.tampilkanRiwayatPelayanan();
        break;

      case '6': 
        sistem.undoPanggilanLoket();
        break;

      case '0':
        print('Terima kasih telah menggunakan CivilFlow.');
        return;

      default:
        print('Pilihan tidak valid!');
    }
  }
}
