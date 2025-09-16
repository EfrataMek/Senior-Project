/*
  Warnings:

  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[password]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[phone_number]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[image_path]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `date_of_birth` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `first_name` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `middle_name` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `password` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone_number` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `role` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "public"."Role" AS ENUM ('Student', 'Teacher', 'Admin');

-- CreateEnum
CREATE TYPE "public"."Attendance_Status" AS ENUM ('Absent', 'Permission');

-- CreateEnum
CREATE TYPE "public"."Schedule_Type" AS ENUM ('Normal', 'Mid_Exam', 'Final_Exam');

-- CreateEnum
CREATE TYPE "public"."User_Status" AS ENUM ('Active', 'Removed', 'Withdraw', 'Graduate');

-- CreateEnum
CREATE TYPE "public"."Question_Type" AS ENUM ('Multiple_Choice', 'True_False', 'Matching', 'Essay');

-- CreateEnum
CREATE TYPE "public"."File_Type" AS ENUM ('Image', 'Document', 'Video', 'Audio');

-- CreateEnum
CREATE TYPE "public"."Group_Type" AS ENUM ('Courses_Per_Term', 'Batch', 'Admin_Created', 'HiLCoE_Official');

-- CreateEnum
CREATE TYPE "public"."Message_Type" AS ENUM ('Individual', 'Group', 'Poll', 'Anonymous_Poll');

-- DropForeignKey
ALTER TABLE "public"."Post" DROP CONSTRAINT "Post_authorId_fkey";

-- AlterTable
ALTER TABLE "public"."User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "name",
ADD COLUMN     "batch_id" INTEGER,
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "date_of_birth" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "first_name" TEXT NOT NULL,
ADD COLUMN     "image_path" TEXT,
ADD COLUMN     "last_name" TEXT NOT NULL,
ADD COLUMN     "middle_name" TEXT NOT NULL,
ADD COLUMN     "password" TEXT NOT NULL,
ADD COLUMN     "phone_number" TEXT NOT NULL,
ADD COLUMN     "role" "public"."Role" NOT NULL,
ADD COLUMN     "user_status" "public"."User_Status" NOT NULL DEFAULT 'Active',
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "User_id_seq";

-- DropTable
DROP TABLE "public"."Post";

-- CreateTable
CREATE TABLE "public"."Room" (
    "id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Room_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Term" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "lecture_start_at" DATE NOT NULL,
    "start_mid_exam" DATE NOT NULL,
    "end_mid_exam" DATE NOT NULL,
    "start_final_exam" DATE NOT NULL,
    "end_final_exam" DATE NOT NULL,
    "lecture_end_date" DATE NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Term_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Category" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "course_id" TEXT NOT NULL,
    "creator_id" TEXT NOT NULL,
    "parent_category_id" INTEGER,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Sections" (
    "id" SERIAL NOT NULL,
    "section" CHAR(1) NOT NULL,
    "batch_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Batch" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Batch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Student_Course_Enrollment" (
    "id" SERIAL NOT NULL,
    "student_id" TEXT NOT NULL,
    "courses_per_term_id" INTEGER NOT NULL,
    "sections_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Student_Course_Enrollment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Attendance" (
    "id" SERIAL NOT NULL,
    "student_course_enrollment_id" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "Schedule_id" INTEGER NOT NULL,
    "status" "public"."Attendance_Status" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Course" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Prerequesties" (
    "id" SERIAL NOT NULL,
    "course_id" TEXT NOT NULL,
    "prereq_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Prerequesties_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Teachers_Per_Course_Term" (
    "id" SERIAL NOT NULL,
    "teacher_id" TEXT NOT NULL,
    "courses_per_term_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Teachers_Per_Course_Term_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Courses_Per_Term" (
    "id" SERIAL NOT NULL,
    "term_id" INTEGER NOT NULL,
    "course_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Courses_Per_Term_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Schedule" (
    "id" SERIAL NOT NULL,
    "teachers_per_course_term_id" INTEGER NOT NULL,
    "sections_id" INTEGER NOT NULL,
    "day" INTEGER NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "room_id" TEXT NOT NULL,
    "type" "public"."Schedule_Type" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Multiple_Choice_Options" (
    "id" SERIAL NOT NULL,
    "multiple_choice_question_bank_id" INTEGER NOT NULL,
    "choice" TEXT NOT NULL,
    "is_answer" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Multiple_Choice_Options_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Multiple_Choice_Question_Bank" (
    "id" SERIAL NOT NULL,
    "question" TEXT NOT NULL,
    "creator_id" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Multiple_Choice_Question_Bank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Multiple_Choice_Question" (
    "id" SERIAL NOT NULL,
    "multiple_choice_question_bank_id" INTEGER NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "weight" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Multiple_Choice_Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."True_False_Question_Bank" (
    "id" SERIAL NOT NULL,
    "question" TEXT NOT NULL,
    "answer" BOOLEAN NOT NULL,
    "creator_id" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "True_False_Question_Bank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."True_False_Question" (
    "id" SERIAL NOT NULL,
    "true_false_question_bank_id" INTEGER NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "weight" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "True_False_Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Matching_Column_A_Bank" (
    "id" SERIAL NOT NULL,
    "question" TEXT NOT NULL,
    "answer_id" INTEGER NOT NULL,
    "creator_id" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Matching_Column_A_Bank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Matching_Column_A" (
    "id" SERIAL NOT NULL,
    "matching_column_A_bank_id" INTEGER NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "weight" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Matching_Column_A_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Matching_Column_B" (
    "id" SERIAL NOT NULL,
    "question" TEXT NOT NULL,

    CONSTRAINT "Matching_Column_B_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Essay_Question_Bank" (
    "id" SERIAL NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT NOT NULL,
    "creator_id" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Essay_Question_Bank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Essay_Question" (
    "id" SERIAL NOT NULL,
    "essay_question_bank_id" INTEGER NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "weight" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Essay_Question_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Instruction_Bank" (
    "id" SERIAL NOT NULL,
    "instruction" TEXT NOT NULL,
    "question_type" "public"."Question_Type" NOT NULL,
    "creator_id" TEXT NOT NULL,
    "is_perfect_score_only_for_multiple_choice" BOOLEAN NOT NULL DEFAULT false,
    "order_of_question_type_appearance" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Instruction_Bank_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Instruction" (
    "instruction_bank_id" INTEGER NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "is_perfect_score_only_for_multiple_choice" BOOLEAN,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "public"."Assessment" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "teachers_per_course_term_id" INTEGER NOT NULL,
    "is_posted" BOOLEAN NOT NULL DEFAULT false,
    "start_time" TIMESTAMP(3) NOT NULL,
    "duration" TIME,
    "due_date" TIMESTAMP(3) NOT NULL,
    "weight" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Assessment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Assessment_for_sections" (
    "id" SERIAL NOT NULL,
    "assessment_id" INTEGER NOT NULL,
    "sections_id" INTEGER NOT NULL,

    CONSTRAINT "Assessment_for_sections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Students_answer_for_Assessment" (
    "id" SERIAL NOT NULL,
    "student_course_enrollment_id" INTEGER NOT NULL,
    "assessment_for_sections_id" INTEGER NOT NULL,
    "feedback" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Students_answer_for_Assessment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Students_answer_for_multiple_choice" (
    "id" SERIAL NOT NULL,
    "students_answer_for_Assessment_id" INTEGER NOT NULL,
    "multiple_choice_option_id" INTEGER NOT NULL,

    CONSTRAINT "Students_answer_for_multiple_choice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Students_answer_for_true_false" (
    "id" SERIAL NOT NULL,
    "students_answer_for_Assessment_id" INTEGER NOT NULL,
    "true_false_question_id" INTEGER NOT NULL,
    "answer" BOOLEAN NOT NULL,

    CONSTRAINT "Students_answer_for_true_false_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Students_answer_for_matching" (
    "id" SERIAL NOT NULL,
    "students_answer_for_Assessment_id" INTEGER NOT NULL,
    "matching_column_a_id" INTEGER NOT NULL,
    "answer_id" INTEGER NOT NULL,

    CONSTRAINT "Students_answer_for_matching_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Students_answer_for_essay" (
    "id" SERIAL NOT NULL,
    "students_answer_for_Assessment_id" INTEGER NOT NULL,
    "essay_question_id" INTEGER NOT NULL,
    "answer" TEXT NOT NULL,
    "grade" DECIMAL(65,30) NOT NULL,

    CONSTRAINT "Students_answer_for_essay_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."All_Files" (
    "id" SERIAL NOT NULL,
    "file_path" TEXT NOT NULL,
    "file_type" "public"."File_Type" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "All_Files_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Messages" (
    "id" SERIAL NOT NULL,
    "content" TEXT,
    "file_id" INTEGER,
    "sender_id" TEXT NOT NULL,
    "replied_to_message_id" INTEGER,
    "message_type" "public"."Message_Type" NOT NULL,

    CONSTRAINT "Messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Group_Metadata" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "group_type" "public"."Group_Type" NOT NULL,
    "group_type_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Group_Metadata_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Group_Members_for_Admin_Created" (
    "id" SERIAL NOT NULL,
    "member_id" TEXT NOT NULL,
    "group_metadata_id" INTEGER NOT NULL,
    "joined_date" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Group_Members_for_Admin_Created_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Group_Message" (
    "id" SERIAL NOT NULL,
    "is_announcement" BOOLEAN NOT NULL DEFAULT false,
    "is_forwarded" BOOLEAN NOT NULL DEFAULT false,
    "message_id" INTEGER NOT NULL,
    "group_metadata_id" INTEGER NOT NULL,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Group_Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Group_Message_Seen" (
    "id" SERIAL NOT NULL,
    "group_message_id" INTEGER NOT NULL,
    "seen_by_id" TEXT NOT NULL,
    "seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Group_Message_Seen_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Individual_Message" (
    "id" SERIAL NOT NULL,
    "is_forwarded" BOOLEAN NOT NULL DEFAULT false,
    "message_id" INTEGER NOT NULL,
    "receiver_id" TEXT NOT NULL,
    "seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sent_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Individual_Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Poll_Options" (
    "id" SERIAL NOT NULL,
    "message_id" INTEGER NOT NULL,
    "option" TEXT NOT NULL,

    CONSTRAINT "Poll_Options_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Polls_Choosen" (
    "id" SERIAL NOT NULL,
    "poll_option_id" INTEGER NOT NULL,
    "chooser_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Polls_Choosen_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Term_name_key" ON "public"."Term"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Student_Course_Enrollment_student_id_courses_per_term_id_key" ON "public"."Student_Course_Enrollment"("student_id", "courses_per_term_id");

-- CreateIndex
CREATE UNIQUE INDEX "Course_name_key" ON "public"."Course"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Prerequesties_course_id_prereq_id_key" ON "public"."Prerequesties"("course_id", "prereq_id");

-- CreateIndex
CREATE UNIQUE INDEX "Teachers_Per_Course_Term_teacher_id_courses_per_term_id_key" ON "public"."Teachers_Per_Course_Term"("teacher_id", "courses_per_term_id");

-- CreateIndex
CREATE UNIQUE INDEX "Courses_Per_Term_term_id_course_id_key" ON "public"."Courses_Per_Term"("term_id", "course_id");

-- CreateIndex
CREATE UNIQUE INDEX "Schedule_teachers_per_course_term_id_type_room_id_day_start_key" ON "public"."Schedule"("teachers_per_course_term_id", "type", "room_id", "day", "start_time", "end_time");

-- CreateIndex
CREATE UNIQUE INDEX "Multiple_Choice_Options_multiple_choice_question_bank_id_ch_key" ON "public"."Multiple_Choice_Options"("multiple_choice_question_bank_id", "choice");

-- CreateIndex
CREATE UNIQUE INDEX "Multiple_Choice_Question_assessment_id_multiple_choice_ques_key" ON "public"."Multiple_Choice_Question"("assessment_id", "multiple_choice_question_bank_id");

-- CreateIndex
CREATE UNIQUE INDEX "True_False_Question_assessment_id_true_false_question_bank__key" ON "public"."True_False_Question"("assessment_id", "true_false_question_bank_id");

-- CreateIndex
CREATE UNIQUE INDEX "Matching_Column_A_assessment_id_matching_column_A_bank_id_key" ON "public"."Matching_Column_A"("assessment_id", "matching_column_A_bank_id");

-- CreateIndex
CREATE UNIQUE INDEX "Essay_Question_assessment_id_essay_question_bank_id_key" ON "public"."Essay_Question"("assessment_id", "essay_question_bank_id");

-- CreateIndex
CREATE UNIQUE INDEX "Instruction_assessment_id_instruction_bank_id_key" ON "public"."Instruction"("assessment_id", "instruction_bank_id");

-- CreateIndex
CREATE UNIQUE INDEX "Assessment_for_sections_assessment_id_sections_id_key" ON "public"."Assessment_for_sections"("assessment_id", "sections_id");

-- CreateIndex
CREATE UNIQUE INDEX "Students_answer_for_Assessment_student_course_enrollment_id_key" ON "public"."Students_answer_for_Assessment"("student_course_enrollment_id", "assessment_for_sections_id");

-- CreateIndex
CREATE UNIQUE INDEX "Students_answer_for_multiple_choice_students_answer_for_Ass_key" ON "public"."Students_answer_for_multiple_choice"("students_answer_for_Assessment_id", "multiple_choice_option_id");

-- CreateIndex
CREATE UNIQUE INDEX "Students_answer_for_true_false_students_answer_for_Assessme_key" ON "public"."Students_answer_for_true_false"("students_answer_for_Assessment_id", "true_false_question_id");

-- CreateIndex
CREATE UNIQUE INDEX "Students_answer_for_matching_students_answer_for_Assessment_key" ON "public"."Students_answer_for_matching"("students_answer_for_Assessment_id", "matching_column_a_id");

-- CreateIndex
CREATE UNIQUE INDEX "All_Files_file_path_key" ON "public"."All_Files"("file_path");

-- CreateIndex
CREATE UNIQUE INDEX "Group_Message_Seen_group_message_id_seen_by_id_key" ON "public"."Group_Message_Seen"("group_message_id", "seen_by_id");

-- CreateIndex
CREATE UNIQUE INDEX "Poll_Options_message_id_option_key" ON "public"."Poll_Options"("message_id", "option");

-- CreateIndex
CREATE UNIQUE INDEX "Polls_Choosen_poll_option_id_chooser_id_key" ON "public"."Polls_Choosen"("poll_option_id", "chooser_id");

-- CreateIndex
CREATE UNIQUE INDEX "User_password_key" ON "public"."User"("password");

-- CreateIndex
CREATE UNIQUE INDEX "User_phone_number_key" ON "public"."User"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "User_image_path_key" ON "public"."User"("image_path");

-- AddForeignKey
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "public"."Course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Category" ADD CONSTRAINT "Category_parent_category_id_fkey" FOREIGN KEY ("parent_category_id") REFERENCES "public"."Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Sections" ADD CONSTRAINT "Sections_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."Batch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User" ADD CONSTRAINT "User_batch_id_fkey" FOREIGN KEY ("batch_id") REFERENCES "public"."Batch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Student_Course_Enrollment" ADD CONSTRAINT "Student_Course_Enrollment_student_id_fkey" FOREIGN KEY ("student_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Student_Course_Enrollment" ADD CONSTRAINT "Student_Course_Enrollment_courses_per_term_id_fkey" FOREIGN KEY ("courses_per_term_id") REFERENCES "public"."Courses_Per_Term"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Student_Course_Enrollment" ADD CONSTRAINT "Student_Course_Enrollment_sections_id_fkey" FOREIGN KEY ("sections_id") REFERENCES "public"."Sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Attendance" ADD CONSTRAINT "Attendance_student_course_enrollment_id_fkey" FOREIGN KEY ("student_course_enrollment_id") REFERENCES "public"."Student_Course_Enrollment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Attendance" ADD CONSTRAINT "Attendance_Schedule_id_fkey" FOREIGN KEY ("Schedule_id") REFERENCES "public"."Schedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prerequesties" ADD CONSTRAINT "Prerequesties_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "public"."Course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prerequesties" ADD CONSTRAINT "Prerequesties_prereq_id_fkey" FOREIGN KEY ("prereq_id") REFERENCES "public"."Course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Teachers_Per_Course_Term" ADD CONSTRAINT "Teachers_Per_Course_Term_teacher_id_fkey" FOREIGN KEY ("teacher_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Teachers_Per_Course_Term" ADD CONSTRAINT "Teachers_Per_Course_Term_courses_per_term_id_fkey" FOREIGN KEY ("courses_per_term_id") REFERENCES "public"."Courses_Per_Term"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Courses_Per_Term" ADD CONSTRAINT "Courses_Per_Term_term_id_fkey" FOREIGN KEY ("term_id") REFERENCES "public"."Term"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Courses_Per_Term" ADD CONSTRAINT "Courses_Per_Term_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "public"."Course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Schedule" ADD CONSTRAINT "Schedule_teachers_per_course_term_id_fkey" FOREIGN KEY ("teachers_per_course_term_id") REFERENCES "public"."Teachers_Per_Course_Term"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Schedule" ADD CONSTRAINT "Schedule_sections_id_fkey" FOREIGN KEY ("sections_id") REFERENCES "public"."Sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Schedule" ADD CONSTRAINT "Schedule_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "public"."Room"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Multiple_Choice_Options" ADD CONSTRAINT "Multiple_Choice_Options_multiple_choice_question_bank_id_fkey" FOREIGN KEY ("multiple_choice_question_bank_id") REFERENCES "public"."Multiple_Choice_Question_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Multiple_Choice_Question_Bank" ADD CONSTRAINT "Multiple_Choice_Question_Bank_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Multiple_Choice_Question" ADD CONSTRAINT "Multiple_Choice_Question_multiple_choice_question_bank_id_fkey" FOREIGN KEY ("multiple_choice_question_bank_id") REFERENCES "public"."Multiple_Choice_Question_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Multiple_Choice_Question" ADD CONSTRAINT "Multiple_Choice_Question_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."True_False_Question_Bank" ADD CONSTRAINT "True_False_Question_Bank_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."True_False_Question" ADD CONSTRAINT "True_False_Question_true_false_question_bank_id_fkey" FOREIGN KEY ("true_false_question_bank_id") REFERENCES "public"."True_False_Question_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."True_False_Question" ADD CONSTRAINT "True_False_Question_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Matching_Column_A_Bank" ADD CONSTRAINT "Matching_Column_A_Bank_answer_id_fkey" FOREIGN KEY ("answer_id") REFERENCES "public"."Matching_Column_B"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Matching_Column_A_Bank" ADD CONSTRAINT "Matching_Column_A_Bank_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Matching_Column_A" ADD CONSTRAINT "Matching_Column_A_matching_column_A_bank_id_fkey" FOREIGN KEY ("matching_column_A_bank_id") REFERENCES "public"."Matching_Column_A_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Matching_Column_A" ADD CONSTRAINT "Matching_Column_A_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Essay_Question_Bank" ADD CONSTRAINT "Essay_Question_Bank_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Essay_Question" ADD CONSTRAINT "Essay_Question_essay_question_bank_id_fkey" FOREIGN KEY ("essay_question_bank_id") REFERENCES "public"."Essay_Question_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Essay_Question" ADD CONSTRAINT "Essay_Question_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Instruction_Bank" ADD CONSTRAINT "Instruction_Bank_creator_id_fkey" FOREIGN KEY ("creator_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Instruction" ADD CONSTRAINT "Instruction_instruction_bank_id_fkey" FOREIGN KEY ("instruction_bank_id") REFERENCES "public"."Instruction_Bank"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Instruction" ADD CONSTRAINT "Instruction_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Assessment" ADD CONSTRAINT "Assessment_teachers_per_course_term_id_fkey" FOREIGN KEY ("teachers_per_course_term_id") REFERENCES "public"."Teachers_Per_Course_Term"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Assessment_for_sections" ADD CONSTRAINT "Assessment_for_sections_assessment_id_fkey" FOREIGN KEY ("assessment_id") REFERENCES "public"."Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Assessment_for_sections" ADD CONSTRAINT "Assessment_for_sections_sections_id_fkey" FOREIGN KEY ("sections_id") REFERENCES "public"."Sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_Assessment" ADD CONSTRAINT "Students_answer_for_Assessment_student_course_enrollment_i_fkey" FOREIGN KEY ("student_course_enrollment_id") REFERENCES "public"."Student_Course_Enrollment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_Assessment" ADD CONSTRAINT "Students_answer_for_Assessment_assessment_for_sections_id_fkey" FOREIGN KEY ("assessment_for_sections_id") REFERENCES "public"."Assessment_for_sections"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_multiple_choice" ADD CONSTRAINT "Students_answer_for_multiple_choice_students_answer_for_As_fkey" FOREIGN KEY ("students_answer_for_Assessment_id") REFERENCES "public"."Students_answer_for_Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_multiple_choice" ADD CONSTRAINT "Students_answer_for_multiple_choice_multiple_choice_option_fkey" FOREIGN KEY ("multiple_choice_option_id") REFERENCES "public"."Multiple_Choice_Options"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_true_false" ADD CONSTRAINT "Students_answer_for_true_false_students_answer_for_Assessm_fkey" FOREIGN KEY ("students_answer_for_Assessment_id") REFERENCES "public"."Students_answer_for_Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_true_false" ADD CONSTRAINT "Students_answer_for_true_false_true_false_question_id_fkey" FOREIGN KEY ("true_false_question_id") REFERENCES "public"."True_False_Question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_matching" ADD CONSTRAINT "Students_answer_for_matching_students_answer_for_Assessmen_fkey" FOREIGN KEY ("students_answer_for_Assessment_id") REFERENCES "public"."Students_answer_for_Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_matching" ADD CONSTRAINT "Students_answer_for_matching_matching_column_a_id_fkey" FOREIGN KEY ("matching_column_a_id") REFERENCES "public"."Matching_Column_A"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_matching" ADD CONSTRAINT "Students_answer_for_matching_answer_id_fkey" FOREIGN KEY ("answer_id") REFERENCES "public"."Matching_Column_B"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_essay" ADD CONSTRAINT "Students_answer_for_essay_students_answer_for_Assessment_i_fkey" FOREIGN KEY ("students_answer_for_Assessment_id") REFERENCES "public"."Students_answer_for_Assessment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Students_answer_for_essay" ADD CONSTRAINT "Students_answer_for_essay_essay_question_id_fkey" FOREIGN KEY ("essay_question_id") REFERENCES "public"."Essay_Question"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Messages" ADD CONSTRAINT "Messages_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "public"."All_Files"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Messages" ADD CONSTRAINT "Messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Messages" ADD CONSTRAINT "Messages_replied_to_message_id_fkey" FOREIGN KEY ("replied_to_message_id") REFERENCES "public"."Messages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Members_for_Admin_Created" ADD CONSTRAINT "Group_Members_for_Admin_Created_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Members_for_Admin_Created" ADD CONSTRAINT "Group_Members_for_Admin_Created_group_metadata_id_fkey" FOREIGN KEY ("group_metadata_id") REFERENCES "public"."Group_Metadata"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Message" ADD CONSTRAINT "Group_Message_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."Messages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Message" ADD CONSTRAINT "Group_Message_group_metadata_id_fkey" FOREIGN KEY ("group_metadata_id") REFERENCES "public"."Group_Metadata"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Message_Seen" ADD CONSTRAINT "Group_Message_Seen_group_message_id_fkey" FOREIGN KEY ("group_message_id") REFERENCES "public"."Group_Message"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Group_Message_Seen" ADD CONSTRAINT "Group_Message_Seen_seen_by_id_fkey" FOREIGN KEY ("seen_by_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Individual_Message" ADD CONSTRAINT "Individual_Message_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."Messages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Individual_Message" ADD CONSTRAINT "Individual_Message_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Poll_Options" ADD CONSTRAINT "Poll_Options_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."Messages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Polls_Choosen" ADD CONSTRAINT "Polls_Choosen_poll_option_id_fkey" FOREIGN KEY ("poll_option_id") REFERENCES "public"."Poll_Options"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Polls_Choosen" ADD CONSTRAINT "Polls_Choosen_chooser_id_fkey" FOREIGN KEY ("chooser_id") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
