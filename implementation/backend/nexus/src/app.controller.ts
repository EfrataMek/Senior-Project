import { Body, Controller, Get, Post } from '@nestjs/common';
import { AppService } from './app.service';
import { DatabaseService } from "./database/database.service";

@Controller()
export class AppController {
  constructor(private readonly appService: AppService, private databaseService : DatabaseService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

   @Post('users')
  async signup(@Body() userData: { name: string, email: string }) {
    return this.databaseService.user.create({ data: userData });
  }

   @Get('getAllUsers')
  async getAllUsers() {
    return this.databaseService.user.findMany();
  }
}
