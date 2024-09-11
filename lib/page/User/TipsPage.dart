import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';

class TipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: white,
        title: Text('Tips Karir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Tips Menulis CV'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TipsCVPage()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Tips Wawancara'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TipsInterviewPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TipsCVPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tips Menulis CV'),
        backgroundColor: darkBlue,
        foregroundColor: white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTip(
              title: '1. Pilih Format yang Jelas dan Profesional',
              explanation:
                  'Gunakan format yang bersih dan terstruktur agar mudah dibaca oleh perekrut. Pilih font yang profesional dan ukuran yang sesuai.',
              example:
                  'Format CV:\nFont: Arial, 11 pt\nHeading: Bold dan ukuran 14 pt\nContoh:\n- Pengalaman Kerja\n- Pendidikan\n- Keterampilan',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '2. Sertakan Informasi Kontak yang Akurat',
              explanation:
                  'Pastikan informasi kontak Anda lengkap dan up-to-date sehingga perekrut dapat menghubungi Anda dengan mudah.',
              example:
                  'Nama: John Doe\nEmail: johndoe@example.com\nTelepon: +62 812 3456 7890\nLinkedIn: linkedin.com/in/johndoe',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '3. Tulis Ringkasan Profil yang Menarik',
              explanation:
                  'Tulis ringkasan singkat yang menjelaskan keahlian utama dan tujuan karir Anda. Fokuskan pada bagaimana Anda bisa memberikan nilai tambah kepada perusahaan.',
              example:
                  'Ringkasan Profil: "Profesional pemasaran dengan 5 tahun pengalaman dalam pengembangan strategi digital dan manajemen proyek. Terampil dalam analisis data dan pengembangan kampanye yang meningkatkan keterlibatan pelanggan."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '4. Detailkan Pengalaman Kerja Anda',
              explanation:
                  'Cantumkan pengalaman kerja Anda terbaru terlebih dahulu. Sertakan tanggung jawab dan pencapaian utama dalam setiap posisi.',
              example:
                  'Jabatan: Marketing Manager\nPerusahaan: XYZ Corp\nTanggal: Januari 2020 - Sekarang\nTanggung Jawab: Mengelola tim pemasaran, mengembangkan kampanye digital, dan menganalisis performa iklan.\nPencapaian: "Meningkatkan penjualan online sebesar 30% dalam 6 bulan."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '5. Soroti Pendidikan dan Kualifikasi',
              explanation:
                  'Cantumkan riwayat pendidikan Anda serta kualifikasi tambahan yang relevan dengan pekerjaan yang dilamar.',
              example:
                  'Gelar: Sarjana Manajemen\nInstitusi: Universitas ABC\nTahun Lulus: 2018\nSertifikasi: Sertifikasi Google Analytics',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '6. Daftarkan Keterampilan yang Relevan',
              explanation:
                  'Sebutkan keterampilan yang sesuai dengan pekerjaan yang Anda lamar. Ini bisa mencakup keterampilan teknis dan soft skills.',
              example:
                  'Keterampilan Teknis: SEO, Google Analytics, Microsoft Excel\nSoft Skills: Kepemimpinan, Komunikasi, Manajemen Waktu',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '7. Sesuaikan CV untuk Setiap Pekerjaan',
              explanation:
                  'Modifikasi CV Anda agar sesuai dengan kualifikasi yang dicari oleh pekerjaan tertentu. Gunakan kata kunci dari deskripsi pekerjaan.',
              example:
                  'Jika pekerjaan memerlukan keterampilan manajemen proyek, soroti pengalaman Anda dalam proyek-proyek besar dan metodologi yang Anda gunakan.',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '8. Gunakan Data dan Angka untuk Menunjukkan Pencapaian',
              explanation:
                  'Sertakan data atau angka yang menggambarkan pencapaian Anda secara konkret.',
              example:
                  'Pencapaian: "Meningkatkan keterlibatan media sosial sebesar 50% dalam 3 bulan melalui strategi konten yang inovatif."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '9. Proofreading dan Koreksi',
              explanation:
                  'Periksa tata bahasa, ejaan, dan format untuk menghindari kesalahan yang dapat mempengaruhi kesan profesional Anda.',
              example:
                  'Gunakan alat pengecekan ejaan atau minta seseorang untuk membaca CV Anda sebelum mengirimkannya.',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '10. Pertahankan Panjang CV yang Tepat',
              explanation:
                  'Usahakan CV Anda tidak lebih dari dua halaman untuk memastikan informasi tetap ringkas dan relevan.',
              example:
                  'Panjang CV: 1-2 halaman\nFormat: Gunakan bullet points untuk ringkas dan padat.',
            ),
          ],
        ),
      ),
    );
  }
}

class TipsInterviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkBlue,
        foregroundColor: white,
        title: Text('Tips Wawancara'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTip(
              title: '1. Riset Perusahaan',
              explanation:
                  'Pelajari tentang sejarah, visi, misi, dan budaya perusahaan. Ini akan membantu Anda menjawab pertanyaan dengan relevansi dan menunjukkan bahwa Anda serius terhadap posisi tersebut.',
              example:
                  '"Saya membaca bahwa perusahaan Anda baru saja meluncurkan produk inovatif yang meningkatkan kepuasan pelanggan sebesar 20%. Saya sangat terkesan dengan pencapaian ini dan ingin tahu lebih banyak tentang bagaimana tim Anda mencapainya."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '2. Persiapkan Jawaban untuk Pertanyaan Umum',
              explanation:
                  'Antisipasi pertanyaan yang sering ditanyakan dalam wawancara seperti kekuatan dan kelemahan Anda, pengalaman kerja, dan alasan Anda melamar pekerjaan tersebut.',
              example:
                  '"Kelemahan saya adalah cenderung terlalu perfeksionis. Namun, saya telah belajar untuk menetapkan prioritas dan mengelola waktu dengan lebih baik untuk menghindari masalah ini."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '3. Berlatih Menjawab Pertanyaan dengan Jelas',
              explanation:
                  'Latih jawaban Anda agar singkat dan langsung ke poin. Gunakan metode STAR (Situation, Task, Action, Result) untuk struktur jawaban yang baik.',
              example:
                  '"Dalam proyek sebelumnya, saya menghadapi situasi di mana deadline mepet (Situation). Tugas saya adalah mengatur ulang prioritas (Task). Saya memimpin tim dalam merestrukturisasi jadwal (Action). Akibatnya, kami berhasil menyelesaikan proyek dua hari lebih awal dari yang direncanakan (Result)."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '4. Kenali dan Tanyakan Pertanyaan kepada Pewawancara',
              explanation:
                  'Tanyakan pertanyaan yang menunjukkan ketertarikan Anda pada perusahaan dan posisi tersebut. Ini juga memberikan Anda informasi yang lebih baik tentang pekerjaan yang akan Anda lakukan.',
              example:
                  '"Bisakah Anda menjelaskan struktur tim dan bagaimana posisi ini berkontribusi dalam mencapai tujuan perusahaan?"',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '5. Tampilkan Kepercayaan Diri dan Sikap Positif',
              explanation:
                  'Perlihatkan bahwa Anda percaya diri dengan sikap positif dan antusiasme. Jangan ragu untuk menunjukkan kemauan Anda untuk belajar dan berkembang.',
              example:
                  '"Saya sangat tertarik dengan kesempatan ini dan percaya bahwa keterampilan saya dalam manajemen proyek dapat membawa dampak positif pada tim Anda. Saya juga bersemangat untuk belajar lebih lanjut tentang teknologi terbaru di bidang ini."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '6. Kenakan Pakaian yang Tepat',
              explanation:
                  'Pilih pakaian yang sesuai dengan budaya perusahaan dan posisi yang Anda lamar. Pakaian yang profesional akan meningkatkan kesan pertama Anda.',
              example:
                  '"Jika wawancara diadakan di perusahaan teknologi, Anda bisa memilih pakaian formal seperti jas dan dasi. Namun, jika perusahaan lebih santai, berpakaian smart casual mungkin lebih sesuai."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '7. Datang Tepat Waktu',
              explanation:
                  'Pastikan Anda tiba di lokasi wawancara tepat waktu atau beberapa menit lebih awal. Ini menunjukkan bahwa Anda menghargai waktu pewawancara dan siap untuk wawancara.',
              example:
                  '"Jika wawancara dijadwalkan pukul 10 pagi, usahakan untuk tiba di lokasi sekitar pukul 9:45 pagi agar Anda memiliki waktu untuk menyiapkan diri dan menenangkan diri sebelum wawancara dimulai."',
            ),
            SizedBox(height: 16),
            _buildTip(
              title: '8. Follow-Up setelah Wawancara',
              explanation:
                  'Kirimkan email ucapan terima kasih setelah wawancara. Ini menunjukkan profesionalisme dan minat Anda pada posisi tersebut.',
              example:
                  '"Terima kasih atas kesempatan wawancara hari ini. Saya sangat antusias mengenai peluang untuk bergabung dengan tim Anda dan yakin bahwa pengalaman saya akan memberikan kontribusi yang berarti. Saya berharap dapat mendengar kabar dari Anda segera."',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTip(
    {required String title,
    required String explanation,
    required String example}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(height: 8),
      Text(
        'Penjelasan: $explanation',
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 8),
      Text(
        'Contoh:\n$example',
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}
