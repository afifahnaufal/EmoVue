-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 01 Jul 2025 pada 08.32
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `emosync`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `chats`
--

CREATE TABLE `chats` (
  `chat_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `emotions`
--

CREATE TABLE `emotions` (
  `id` int(11) NOT NULL,
  `emotion` varchar(50) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `emotions`
--

INSERT INTO `emotions` (`id`, `emotion`, `timestamp`, `created_at`, `updated_at`) VALUES
(11, 'Marah', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03'),
(12, 'Stres', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03'),
(13, 'Sedih', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03'),
(14, 'Senang', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03'),
(15, 'Tenang', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03'),
(16, 'Netral', '2025-06-22 15:56:03', '2025-06-22 08:56:03', '2025-06-22 08:56:03');

-- --------------------------------------------------------

--
-- Struktur dari tabel `emotion_analysis`
--

CREATE TABLE `emotion_analysis` (
  `analysis_id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `detected_emotion` enum('senang','marah','netral','stres','sedih') NOT NULL,
  `confidence_score` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `emotion_logs`
--

CREATE TABLE `emotion_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `intensity` int(11) DEFAULT NULL CHECK (`intensity` between 1 and 5),
  `emotion_trigger` varchar(100) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `emotion` enum('senang','marah','netral','stres','sedih') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `emotion_logs`
--

INSERT INTO `emotion_logs` (`log_id`, `user_id`, `intensity`, `emotion_trigger`, `duration`, `notes`, `emotion`, `created_at`) VALUES
(1, 1, 3, 'Manual input', NULL, 'im so happy because i got my new phone from my dad', 'senang', '2025-06-09 08:31:57'),
(2, 1, 3, 'Manual input', NULL, 'im very happy i got new phone from my dad', 'senang', '2025-06-09 08:38:55'),
(3, 1, 3, 'Manual input', NULL, 'im so happy i got my new phone', 'senang', '2025-06-09 09:03:46'),
(4, 1, 3, 'Manual input', NULL, 'angry', 'senang', '2025-06-09 09:04:00'),
(5, 1, 3, 'Manual input', NULL, 'im so happy i got my new phone', 'senang', '2025-06-09 09:15:15'),
(6, 1, 3, 'Manual input', NULL, 'im so happy', 'senang', '2025-06-25 09:35:52'),
(7, 1, 3, 'Manual input', NULL, 'im so sad', 'sedih', '2025-06-09 09:36:03'),
(8, 1, 3, 'Manual input', NULL, 'angry', 'marah', '2025-06-09 09:36:19'),
(9, 1, 3, 'Manual input', NULL, 'sad', 'sedih', '2025-06-25 10:08:08'),
(10, 1, 3, 'Manual input', NULL, 'im so happy because i got my new phone from my dad', 'senang', '2025-06-08 01:31:57'),
(11, 1, 3, 'Manual input', NULL, 'im very happy i got new phone from my dad', 'senang', '2025-06-08 01:38:55'),
(12, 1, 3, 'Manual input', NULL, 'im so happy i got my new phone', 'senang', '2025-06-07 20:46:00'),
(13, 1, 3, 'Manual input', NULL, 'angry', 'senang', '2025-06-07 21:00:00'),
(14, 1, 3, 'Manual input', NULL, 'im so happy i got my new phone', 'senang', '2025-06-08 08:15:00'),
(15, 1, 3, 'Manual input', NULL, 'im so happy', 'senang', '0000-00-00 00:00:00'),
(16, 1, 3, 'Manual input', NULL, 'im so sad', 'sedih', '0000-00-00 00:00:00'),
(17, 1, 3, 'Manual input', NULL, 'angry', 'marah', '0000-00-00 00:00:00'),
(18, 1, 3, 'Manual input', NULL, 'sad', 'sedih', '2025-06-08 03:08:08'),
(19, 1, 3, 'Manual input', NULL, 'im so happy', 'senang', '2025-06-16 03:56:57'),
(20, 1, 3, 'Manual input', NULL, 'iam very happy because i got new bike', 'netral', '2025-06-25 04:02:53'),
(21, 1, 3, 'Manual input', NULL, 'im very happy', 'senang', '2025-06-16 04:03:24'),
(22, 1, 3, 'Manual input', NULL, 'iam so angry and stress', 'marah', '2025-06-25 11:43:53'),
(23, 1, 3, 'Manual input', NULL, 'im so angry and stress', 'marah', '2025-06-21 13:35:46'),
(24, 1, 3, 'Manual input', NULL, 'im so stress', 'marah', '2025-06-21 13:38:16'),
(25, 1, 3, 'Manual input', NULL, 'im so stress', 'marah', '2025-06-21 13:40:22'),
(26, 1, 3, 'Manual input', NULL, 'so angry', 'marah', '2025-06-21 13:42:31'),
(27, 1, 3, 'Manual input', NULL, 'so angry and stress', 'marah', '2025-06-21 14:01:57'),
(28, 1, 3, 'Manual input', NULL, 'aku sangat marah', 'marah', '2025-06-21 14:12:19'),
(29, 1, 3, 'Manual input', NULL, 'aku sedang stress dan marah sekali', 'marah', '2025-06-21 14:16:48'),
(30, 1, 3, 'Manual input', NULL, 'aku sangan marah dan juga stress', 'marah', '2025-06-21 14:24:23'),
(31, 1, 3, 'Manual input', NULL, 'sangat marah di tambah stress', 'marah', '2025-06-21 14:30:46'),
(32, 1, 3, 'Manual input', NULL, 'aku sangat stress di tambah marah', 'marah', '2025-06-21 14:39:01'),
(33, 1, 3, 'Manual input', NULL, 'happy', 'senang', '2025-06-21 14:39:14'),
(34, 1, 3, 'Manual input', NULL, 'marah banget sama stress', 'marah', '2025-06-21 14:58:07'),
(35, 1, 3, 'Manual input', NULL, 'marah dan stress sekali', 'marah', '2025-06-21 15:00:40'),
(36, 1, 3, 'Manual input', NULL, 'aku merasa akhir akhir ini depresi dengan pekerjaan aku', 'sedih', '2025-06-25 15:05:23'),
(37, 1, 3, 'Manual input', NULL, 'aku sangat depresi karna kerjaan dan masalah di rumah', 'marah', '2025-06-21 15:08:39'),
(38, 1, 3, 'Manual input', NULL, 'marah sedih', 'marah', '2025-06-27 07:46:47'),
(39, 1, 3, 'Manual input', NULL, 'depresi putus asa', 'marah', '2025-06-27 07:48:46'),
(40, 1, 3, 'Manual input', NULL, 'saya depresi dan merasa putus asa', 'marah', '2025-06-30 14:52:54'),
(41, 1, 3, 'Manual input', NULL, 'aku sangat happy dan gembira', 'senang', '2025-06-30 14:55:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `teams`
--

CREATE TABLE `teams` (
  `team_id` int(11) NOT NULL,
  `team_name` varchar(100) NOT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `team_members`
--

CREATE TABLE `team_members` (
  `team_member_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','member') DEFAULT 'member',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'default_user', 'default@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'member', '2025-06-09 06:49:42');

-- --------------------------------------------------------

--
-- Struktur dari tabel `user_emotions`
--

CREATE TABLE `user_emotions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `emotion_id` int(11) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `weekly_reflections`
--

CREATE TABLE `weekly_reflections` (
  `reflection_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `week_start` date NOT NULL,
  `week_end` date NOT NULL,
  `summary_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`chat_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indeks untuk tabel `emotions`
--
ALTER TABLE `emotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `emotion` (`emotion`),
  ADD KEY `idx_emotion` (`emotion`);

--
-- Indeks untuk tabel `emotion_analysis`
--
ALTER TABLE `emotion_analysis`
  ADD PRIMARY KEY (`analysis_id`),
  ADD UNIQUE KEY `chat_id` (`chat_id`);

--
-- Indeks untuk tabel `emotion_logs`
--
ALTER TABLE `emotion_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`team_id`),
  ADD KEY `owner_id` (`owner_id`);

--
-- Indeks untuk tabel `team_members`
--
ALTER TABLE `team_members`
  ADD PRIMARY KEY (`team_member_id`),
  ADD KEY `team_id` (`team_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `user_emotions`
--
ALTER TABLE `user_emotions`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `weekly_reflections`
--
ALTER TABLE `weekly_reflections`
  ADD PRIMARY KEY (`reflection_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `chats`
--
ALTER TABLE `chats`
  MODIFY `chat_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `emotions`
--
ALTER TABLE `emotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `emotion_analysis`
--
ALTER TABLE `emotion_analysis`
  MODIFY `analysis_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `emotion_logs`
--
ALTER TABLE `emotion_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT untuk tabel `teams`
--
ALTER TABLE `teams`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `team_members`
--
ALTER TABLE `team_members`
  MODIFY `team_member_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `user_emotions`
--
ALTER TABLE `user_emotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `weekly_reflections`
--
ALTER TABLE `weekly_reflections`
  MODIFY `reflection_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `chats`
--
ALTER TABLE `chats`
  ADD CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chats_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `emotion_analysis`
--
ALTER TABLE `emotion_analysis`
  ADD CONSTRAINT `emotion_analysis_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`chat_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `emotion_logs`
--
ALTER TABLE `emotion_logs`
  ADD CONSTRAINT `emotion_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `teams`
--
ALTER TABLE `teams`
  ADD CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `team_members`
--
ALTER TABLE `team_members`
  ADD CONSTRAINT `team_members_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `team_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `weekly_reflections`
--
ALTER TABLE `weekly_reflections`
  ADD CONSTRAINT `weekly_reflections_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
